Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8A15325B9A
	for <lists+ceph-devel@lfdr.de>; Wed, 22 May 2019 03:17:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727681AbfEVBRF (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 21 May 2019 21:17:05 -0400
Received: from mail-it1-f178.google.com ([209.85.166.178]:36716 "EHLO
        mail-it1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfEVBRF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 21 May 2019 21:17:05 -0400
Received: by mail-it1-f178.google.com with SMTP id e184so511903ite.1
        for <ceph-devel@vger.kernel.org>; Tue, 21 May 2019 18:17:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=QMVFq2AAueH8ENnNMgyi89v4oXQ/dcA6iYxjWvby7O4=;
        b=cIcUD0Li9rKkiU3r7nNzRXuQcfweCH10vjrq1iSIFokbRfv7/iW/nuW+qsfACZjlJH
         +R9HIk6sxEWTzTCKJZ/VAF2FBEK7ml3EKFAT6yYYXIgPt4LfH8EHBJP0yORtIPf/K7DW
         4BagJBh0vJetRx9Gv6mZ2oR5zqVGzkooHNWIsV7ol/YrbxRwgOEf+TMYsiTWayPW+emL
         zU4WZdvermHkDDNKy+KGPnRDgdj3U9TBFnLSa61IOGlmKgiolitJ++KApKtnTlfZSDwL
         Ql/7sGv94fR/ygSBi+RJouS2X4WjJcKwwZXvR6ZFn6USVlOLAhiF9Y/UWKB572iIXGwD
         oTHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=QMVFq2AAueH8ENnNMgyi89v4oXQ/dcA6iYxjWvby7O4=;
        b=FhxfBGMbDrQ6VwV6EYbpwCBOiWUVo9hojttj/27GZsUSFohtDOXw/1fWlNchYaQ7ZM
         S0GPhS89hrSPMfxkpcddmOsvqzHAvBpFpJfqM7gsCkF3TUGXyYiPF3BsGPzQiqNyByxF
         xXAh0glU1xok/ADzy4O5JVz7iQR6nOAQ8WeufMlsMrOvBMyf1mJ8D0DZ8DeKdwf+TV8Q
         UWwdA3dfnjgOQNt93T4UoTu3eDMKZwFS4HbHJhk9JHmUogQKorMXyVpwABDVwuNDI/YA
         du3wmcJjNm9KK0KI5EJlYqrUTLFDtG25+HduuTGis7ee19oeljR1HdRRnNULYhKX/0es
         qXKA==
X-Gm-Message-State: APjAAAVmctWW8FY2g/Ge2//Pn05maEA2tYLOp4/yEtMXaymitZ4WJxiR
        7PR+WkZ9U7ASh52mVGjPEw00kWB+B+U2fmYQkXv5XhA0
X-Google-Smtp-Source: APXvYqxlqP2xFxSYp6JOAu4lpDQmPXieRSuYpQuKAy/zeaw069c4zEfxGU7wDdFVkdcPsSTvBHHZ8SH8mUKcAV95Exs=
X-Received: by 2002:a24:5a06:: with SMTP id v6mr7053905ita.160.1558487824551;
 Tue, 21 May 2019 18:17:04 -0700 (PDT)
MIME-Version: 1.0
From:   Xiaoxi Chen <superdebuger@gmail.com>
Date:   Wed, 22 May 2019 09:16:51 +0800
Message-ID: <CAEYCsVJ_k_HxRFxts_Vbk8KN8GQ73Kh_JBKf4upE46YrfHGnbA@mail.gmail.com>
Subject: Multisite sync corruption for large multipart obj
To:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

we have a two-zone multi-site setup, zone lvs and zone slc
respectively. It works fine in general however we got reports from
customer about data corruption/mismatch between two zone

root@host:~# s3cmd -c .s3cfg_lvs ls
s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
2019-05-14 04:30 410444223 s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
root@host-ump:~# s3cmd -c .s3cfg_slc ls
s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
2019-05-14 04:30 62158776 s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index

Object metadata in SLC/LVS can be found in
https://pastebin.com/a5JNb9vb LVS
https://pastebin.com/1MuPJ0k1 SLC

SLC is a single flat object while LVS is a multi-part object, which
indicate the object was uploaded by user in LVS and mirrored to
SLC.The SLC object get truncated after 62158776, the first 62158776
bytes are right.

root@host:~# cmp -l slc_obj lvs_obj
cmp: EOF on slc_obj after byte 62158776

Both bucket sync status and overall sync status shows positive, and
the obj was created 5 days ago. It sounds more like when pulling the
object content from source zone(LVS), the transaction was terminated
somewhere in between and cause an incomplete obj, and seems we dont
have checksum verification in sync_agent so that the corrupted obj was
there and be treated as a success sync.

root@host:~# radosgw-admin --cluster slc_ceph_ump bucket sync status
--bucket=ms-nsn-prod-48
realm 2305f95c-9ec9-429b-a455-77265585ef68 (metrics)
zonegroup 9dad103a-3c3c-4f3b-87a0-a15e17b40dae (ebay)
zone 6205e53d-6ce4-4e25-a175-9420d6257345 (slc)
bucket ms-nsn-prod-48[017a0848-cf64-4879-b37d-251f72ff9750.432063.48]

source zone 017a0848-cf64-4879-b37d-251f72ff9750 (lvs)
                full sync: 0/16 shards
                incremental sync: 16/16 shards
                bucket is caught up with source


Re-sync on the bucket will not solve the inconsistency

radosgw-admin bucket sync init --source-zone lvs --bucket=ms-nsn-prod-48

root@host:~# radosgw-admin bucket sync status --bucket=ms-nsn-prod-48
realm 2305f95c-9ec9-429b-a455-77265585ef68 (metrics)
zonegroup 9dad103a-3c3c-4f3b-87a0-a15e17b40dae (ebay)
zone 6205e53d-6ce4-4e25-a175-9420d6257345 (slc)
bucket ms-nsn-prod-48[017a0848-cf64-4879-b37d-251f72ff9750.432063.48]

source zone 017a0848-cf64-4879-b37d-251f72ff9750 (lvs)
                full sync: 0/16 shards
                incremental sync: 16/16 shards
                bucket is caught up with source

root@lvscephmon01-ump:~# s3cmd -c .s3cfg_slc ls
s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index
2019-05-14 04:30 62158776 s3://ms-nsn-prod-48/01DAT9KVPEDE4QTA6EWFBZJ5KS/index


A tracker was submitted to
https://tracker.ceph.com/issues/39992
