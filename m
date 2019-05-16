Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 57948209F7
	for <lists+ceph-devel@lfdr.de>; Thu, 16 May 2019 16:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727121AbfEPOmV (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 May 2019 10:42:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:46284 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726742AbfEPOmV (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 16 May 2019 10:42:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 593A7AC32;
        Thu, 16 May 2019 14:42:19 +0000 (UTC)
From:   Igor Fedotov <ifedotov@suse.de>
To:     ceph-devel <ceph-devel@vger.kernel.org>,
        Sage Weil <sweil@redhat.com>
Subject: Bluestore onode improvements suggestion.
Message-ID: <796fe4f9-ff11-647c-8da9-e85417052a53@suse.de>
Date:   Thu, 16 May 2019 17:42:07 +0300
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi cephers!

Let me share some ideas on Bluestore onode extent map format 
refactoring. The primary drivers for this proposal are some design flaws 
and complexities in extent map sharding, e.g. one causing 
https://tracker.ceph.com/issues/38272

1) I think we can consider an introduction of logical extent size 
granularity. Let's align it with device block size (usually equal to 4KB).

This change will bring some issues in handling small and/or unaligned 
write and zero ops though:

   - For such writes we'll need to read head and tail extents to build 
the whole 4K block. Which we currently do for non-shared and 
non-compressed extents anyway. As a benefit having merged extent 
pointing to a single disk block might improve subsequent reads.

- For small/unaligned zero op handling we'll need to perform actual 
write rather than updating extent map only. And (without special care) a 
sequence of such ops wouldn't actually release space allocated by zeroed 
extents as it might do now.

The major benefit is the significant reduction in amount of extents one 
can expect within some logical span, see below for details.

2) We can prohibit extents/blobs protruding out of 
bluestore_max_blob_size boundaries (64KB for ssd and 512 KB for HDD by 
default). Spanning writes to be split if needed.

As disadvantages one can name potentially less benefit from compression 
and higher amount of blob entries.

But as a result we'll have permanently available sharding points - one 
can always split extent map at known logical offsets and be sure that 
there are no blobs spanning over several resulting shards.

The above constraints also reduces maximum amount of extent/shard 
entries single onode might have. Which probably allows to encode them 
more efficiently, e.g. using bitmaps.

With byte granularity and 128MB maximum onode size one could have up to 
128MB entries.

In the proposed model this reduces to 32K (=128MB /4KB) for extents and 
2K (=128MB/64KB(=max_blob_size_ssd)) for shards.

Maximum amount of extents/blobs per the smallest shard will be 128 (512K 
/ 4K). This might still produce quite heavily encoded shard - the 
suggestion is to perform a sort of garbage collection in this case (when 
shard encoded size reaches some threshold) - collect all (for 
max_blob_size span) the relevant data (including ones in compressed and 
shared blobs) and overwrite it to a single resulting blob.

Generally the above changes are probably enough to fix spanning blob 
issue and simplify sharding. But it might worth to consider the 
following onode substructures' format changes.

3) Refactor shard_info encoding. Currently it takes around 6 bytes per 
single entry (3-4 bytes for "offset" field and 1-2 bytes  for "bytes" 
field).

3.1) Firstly we don't need "bytes" field any more as we don't need to 
estimate average extent size to make decisions during resharding. 
Without "bytes" field we'll need max 8 KB (=2K (max shards) * 4) to keep 
all possible shard_info entries.

3.2) Additionally as we have "granular" shard boundaries (64K/512K 
aligned) we can use bitmap to track them instead. Bit=1 - shard start, 
bit=0 - shard continuation. For 2K shards one needs 256 bytes (=2048/8)  
to keep the full map. I.e. this scheme becomes beneficial over current 
one at 64+ shards. To keep low shard amounts more efficiently we can use 
mixed scheme that utilizes offset enumeration for low density cases and 
evolve to bitmap for higher ones.

4) Replace existing logical extent + blob encoding scheme with a new one:

Current  encoding:

(<extent info: offs, len, blob_offs> + (<blob_id> | <full blob>))*

can probably be replaced with:

(<full blob> + <new_extent_info>)*

where new_extent_info is either

= bitmap (bit length = max extents per shard = 128) => 128 / 8 = max 16 
bytes

or

= (<extent info: offs, len, blob_offs>)*, i.e. set of previous extent 
infos relevant to this specific blob.

The encoding format choice is made by comparison estimated sizes for 
both methods. If estimate current average extent_info's size at 8 bytes 
we can see that bitmap is beneficial for 3+ extents per blob.

This way we cap full set of extents to 16 bytes per blob. Compare to 512 
bytes (= 8 (avg. extent_info) * 64 (=128/2 max standalone extents per 
blob) for the original approach. And we're still on par with the 
original approach when 1-3 extents per blob are present.


What do you think?


Thanks,

Igor


