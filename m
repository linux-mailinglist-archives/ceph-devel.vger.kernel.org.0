Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3110310114
	for <lists+ceph-devel@lfdr.de>; Tue, 30 Apr 2019 22:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbfD3Umb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 30 Apr 2019 16:42:31 -0400
Received: from mail-qk1-f179.google.com ([209.85.222.179]:45786 "EHLO
        mail-qk1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726164AbfD3Umb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 30 Apr 2019 16:42:31 -0400
Received: by mail-qk1-f179.google.com with SMTP id d5so9081426qko.12
        for <ceph-devel@vger.kernel.org>; Tue, 30 Apr 2019 13:42:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-transfer-encoding:content-language;
        bh=A5AXrysdgBqo5dxmnso1WZw+jBBJnpnS1AfCBnYm9dI=;
        b=hpSHg3F+xvOSwUSquc8xtn/mvH4JJT1s3BsXq2mUZAPtaCvMQIIO4vixEnRghHsN4F
         QmasN2Wrskxep+eJgUIbPreleROXKTWRJKkMTCyfQ86Ds7qffTHu//kWfID5xJeowy/V
         bhchUAKuD/HYdQQXM8ouAgWojkdrJIDzolK1WU7AWDb7jvx1B+pabTzCaFxsKQvVIxiw
         X+BjggaxCURC9RJNQHZ8AXQ8yhFYqOwbfAC5RWEUzma3AUl5QaVJnHP7w0eWg0DjKdBF
         UD+XmMQsFX64U2dpceFcwv+OSlCGb0+iAqigjsEBaCcK2Syvh8f4DBvpiVlwNlkB9mOT
         GKqA==
X-Gm-Message-State: APjAAAW2S61URS/tkWBruG4CJGwmtLFCo3JMG6iZ1L3RRly+NT9L9wvI
        uETLuNlv3NmCzw/xNw46QXMAmKu6v28=
X-Google-Smtp-Source: APXvYqzzmZR1kF1NhHhW+1rdggIETDcLSDvEct2yZIq5VX2kPyZ1SPuoLgTuK4iMsAGWlBOkYsOypQ==
X-Received: by 2002:ae9:ef17:: with SMTP id d23mr12381534qkg.55.1556656949808;
        Tue, 30 Apr 2019 13:42:29 -0700 (PDT)
Received: from [10.17.151.126] ([12.118.3.106])
        by smtp.gmail.com with ESMTPSA id z38sm22787419qtz.13.2019.04.30.13.42.26
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 30 Apr 2019 13:42:27 -0700 (PDT)
To:     The Sacred Order of the Squid Cybernetic 
        <ceph-devel@vger.kernel.org>
From:   Casey Bodley <cbodley@redhat.com>
Subject: rgw: bucket deletion in multisite
Message-ID: <564241c1-2cf3-2452-cb21-e32ec9cd5211@redhat.com>
Date:   Tue, 30 Apr 2019 16:42:25 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hi rgw folks, this is a rough design for cleanup of deleted buckets in 
multisite. I would love some review/feedback.

Motivation:
     - Bucket deletion in a multisite configuration does not delete 
bucket instance metadata, bucket sync status, or bucket index objects on 
any zone. This allows bucket sync on each zone to finish processing 
object deletions and (hopefully) converge on empty.

Requirements:
     - Remove all objects associated with deleted buckets in a timely 
manner:
         - bucket instance metadata, bucket index shards, and bucket 
sync status
         - all object data
     - Does not rely on bucket sync to delete all objects [zone A may 
delete an empty bucket that hasn't yet synced objects from zone B, so 
the zones would converge on zone B's objects]
     - Strategy to clean up already-deleted buckets, ie 'radosgw-admin 
bucket stale-instances rm' command

Summary:
     - Add a process for 'deferred bucket deletion', where local bucket 
instance metadata is removed and the bucket index/data are scheduled for 
later 'bucket gc'. A new 'bucket gc list' is stored in omap and 
processed by a worker similar to existing gc.
     - For metadata sync, the metadata log format needs to be extended 
to distinguish between normal writes and deletion events on bucket 
instances. When metadata sync encounters a bucket instance deletion, it 
runs 'deferred bucket deletion'.
     - Data sync on the bucket needs to avoid creating new objects while 
bucket gc is running.

mdlog:
     - entries must distinguish between Write, Remove, and Delete (where 
Delete implies gc of associated data)
     - a 'bucket rm' Deletes its bucket instance metadata
     - a 'bucket reshard' Removes the old bucket instance because the 
new bucket instance still owns the data

Bucket gc list:
     - stored in omap in the log pool
     - sharded over multiple objects
     - each entry encodes RGWBucketInfo (needed to delete objects after 
bucket instance is deleted)

Bucket index:
     - add REMOVE_ONLY flag to bucket index to prevent object creation 
from racing with bucket gc

Deferred bucket delete:
     - flag bucket index shards as REMOVE_ONLY
     - add to 'bucket gc' list (entry includes encoded RGWBucketInfo) 
*requires access to existing bucket instance metadata*
     - delete local bucket instance (add Delete entry to mdlog)

Metadata sync:
     - must serialize sync of mdlog entries with the same metadata key, 
to preserve order of Writes vs Removes/Deletes
         - can skip Writes if they're followed by Removes/Deletes
     - on Delete of bucket instance, run deferred bucket delete
     - backward compatibility: what to do with mdlog entries that don't 
specify Write/Remove/Delete?
         - for bucket instance: assume write (because we never deleted 
them before upgrade), and just try to fetch
         - for other metadata: use existing strategy to fetch remote 
metadata, and remove local metadata on 404/ENOENT

Bucket sync:
     - bucket sync first fetches bucket instance - on ENOENT, exit 
bucket sync with success
     - if sync_object() returns REMOVE_ONLY error from bucket index, 
exit bucket sync with success
     - read/fetch bucket instance metadata before taking lease to avoid 
recreating bucket sync status objects

Bucket gc worker:
     - for each bucket in gc list:
         - decode RGWBucketInfo
         - delete each object in bucket [should we GC tail objects or 
delete inline?]
         - delete incomplete multiparts
         - delete bucket index objects
         - delete bucket sync status objects

radosgw-admin bucket stale-instances rm:
     - run deferred bucket delete on each bucket instance that:
         - does not have an associated bucket entrypoint
         - has a bucket id matching its bucket marker? (has not been 
resharded)
     - must be safe to run on any zone after upgrade
