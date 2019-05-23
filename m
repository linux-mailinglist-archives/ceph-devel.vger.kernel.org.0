Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 034DB28B68
	for <lists+ceph-devel@lfdr.de>; Thu, 23 May 2019 22:15:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387778AbfEWUPa (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 23 May 2019 16:15:30 -0400
Received: from mail-qt1-f171.google.com ([209.85.160.171]:34954 "EHLO
        mail-qt1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726451AbfEWUPa (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 23 May 2019 16:15:30 -0400
Received: by mail-qt1-f171.google.com with SMTP id a39so8353009qtk.2
        for <ceph-devel@vger.kernel.org>; Thu, 23 May 2019 13:15:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=oco8o4BDzsevkODrGu596Gr8jwqy+71GJIUWCzYQhks=;
        b=k9Jm5BMj5Wi9Y0+MITvXtqnMBizpHiH20VUzignyZUT96YY+XiPcS1w7j5Y4b+QWP7
         Y0rKs6/uc7AJ/fOPtayvev36EzMHUy5rB5ALQuI8+udKEufXE0rwghRZuHUWm748wXx8
         MQfrkOJpFlpA3ZX/saVEWCWaDBHQsv9C0hG9VB5kyZDAGe2SiMfIHG2s/nWZ1D62pPQV
         j0NgEZIPdf/W0GKKM1Cl3a8ABzE5Trj/RGcr8hnvccoQkKEcm7tG++oPPkjsoJkCZ77K
         UEx6E3DYGjDuupBg4fwA0492WLWtH8z+zs8ghD7PhNmWwzGEw5sm8JGGuJGBAb4Oo9Tx
         qiOQ==
X-Gm-Message-State: APjAAAWsOcNqqV4ja7VcgI/PPkD14h4JaDOM5SBPGDyOufUqoHtgJfh9
        bCPAKkIf6twE1ZFJ7UxVpI3y1q5lnY0=
X-Google-Smtp-Source: APXvYqyaqD0IkS/Z2kZdiLi+pFj0ETVuzWtjz5oIKzaSJDTXT9SmCsiNh56YJCxmTgRQWXKukchUmQ==
X-Received: by 2002:ac8:414e:: with SMTP id e14mr38526005qtm.343.1558642528833;
        Thu, 23 May 2019 13:15:28 -0700 (PDT)
Received: from [10.17.151.126] ([12.118.3.106])
        by smtp.gmail.com with ESMTPSA id c7sm199925qko.53.2019.05.23.13.15.28
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 May 2019 13:15:28 -0700 (PDT)
Subject: Re: Multisite sync corruption for large multipart obj
To:     Xiaoxi Chen <superdebuger@gmail.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
References: <CAEYCsVJ_k_HxRFxts_Vbk8KN8GQ73Kh_JBKf4upE46YrfHGnbA@mail.gmail.com>
From:   Casey Bodley <cbodley@redhat.com>
Message-ID: <349539bb-bbf2-e900-2972-bd309f2d4fa1@redhat.com>
Date:   Thu, 23 May 2019 16:15:27 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CAEYCsVJ_k_HxRFxts_Vbk8KN8GQ73Kh_JBKf4upE46YrfHGnbA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 5/21/19 9:16 PM, Xiaoxi Chen wrote:
> we have a two-zone multi-site setup, zone lvs and zone slc
> respectively. It works fine in general however we got reports from
> customer about data corruption/mismatch between two zone
>
> root@host:~# s3cmd -c .s3cfg_lvs ls
> s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
> 2019-05-14 04:30 410444223 s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
> root@host-ump:~# s3cmd -c .s3cfg_slc ls
> s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
> 2019-05-14 04:30 62158776 s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
>
> Object metadata in SLC/LVS can be found in
> https://pastebin.com/a5JNb9vb LVS
> https://pastebin.com/1MuPJ0k1 SLC
>
> SLC is a single flat object while LVS is a multi-part object, which
> indicate the object was uploaded by user in LVS and mirrored to
> SLC.The SLC object get truncated after 62158776, the first 62158776
> bytes are right.
>
> root@host:~# cmp -l slc_obj lvs_obj
> cmp: EOF on slc_obj after byte 62158776
>
> Both bucket sync status and overall sync status shows positive, and
> the obj was created 5 days ago. It sounds more like when pulling the
> object content from source zone(LVS), the transaction was terminated
> somewhere in between and cause an incomplete obj, and seems we dont
> have checksum verification in sync_agent so that the corrupted obj was
> there and be treated as a success sync.
It's troubling to see that sync isn't detecting an error from the 
transfer. Do you see any errors from the http client in your logs such 
as 'WARNING: client->receive_data() returned ret='?

I agree that we need integrity checking, but we can't rely on ETags 
because of the way that multipart objects sync as non-multipart. I think 
the right way to address this is to add v4 signature support to the http 
client, and rely on STREAMING-AWS4-HMAC-SHA256-PAYLOAD for integrity of 
the body chunks 
(https://docs.aws.amazon.com/AmazonS3/latest/API/sigv4-streaming.html).

>
> root@host:~# radosgw-admin --cluster slc_ceph_ump bucket sync status
> --bucket=ms-nsn-prod-48
> realm 2305f95c-9ec9-429b-a455-77265585ef68 (metrics)
> zonegroup 9dad103a-3c3c-4f3b-87a0-a15e17b40dae (ebay)
> zone 6205e53d-6ce4-4e25-a175-9420d6257345 (slc)
> bucket ms-nsn-prod-48[017a0848-cf64-4879-b37d-251f72ff9750.432063.48]
>
> source zone 017a0848-cf64-4879-b37d-251f72ff9750 (lvs)
>                  full sync: 0/16 shards
>                  incremental sync: 16/16 shards
>                  bucket is caught up with source
>
>
> Re-sync on the bucket will not solve the inconsistency
Right. The GET requests that fetch objects use the If-Modified-Since 
header to avoid transferring data unless the mtime has changed. In order 
to force re-sync, you would have to do something that updates its mtime 
- for example, setting an acl.
> radosgw-admin bucket sync init --source-zone lvs --bucket=ms-nsn-prod-48
>
> root@host:~# radosgw-admin bucket sync status --bucket=ms-nsn-prod-48
> realm 2305f95c-9ec9-429b-a455-77265585ef68 (metrics)
> zonegroup 9dad103a-3c3c-4f3b-87a0-a15e17b40dae (ebay)
> zone 6205e53d-6ce4-4e25-a175-9420d6257345 (slc)
> bucket ms-nsn-prod-48[017a0848-cf64-4879-b37d-251f72ff9750.432063.48]
>
> source zone 017a0848-cf64-4879-b37d-251f72ff9750 (lvs)
>                  full sync: 0/16 shards
>                  incremental sync: 16/16 shards
>                  bucket is caught up with source
>
> root@lvscephmon01-ump:~# s3cmd -c .s3cfg_slc ls
> s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
> 2019-05-14 04:30 62158776 s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
>
>
> A tracker was submitted to
> https://tracker.ceph.com/issues/39992

