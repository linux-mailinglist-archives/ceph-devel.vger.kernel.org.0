Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0BA333763
	for <lists+ceph-devel@lfdr.de>; Wed, 10 Mar 2021 09:35:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232399AbhCJIfH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 10 Mar 2021 03:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232299AbhCJIfA (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 10 Mar 2021 03:35:00 -0500
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3F35C06174A
        for <ceph-devel@vger.kernel.org>; Wed, 10 Mar 2021 00:35:00 -0800 (PST)
Received: by mail-pf1-x42d.google.com with SMTP id q204so11465526pfq.10
        for <ceph-devel@vger.kernel.org>; Wed, 10 Mar 2021 00:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=OZ4DaFt4QxSyy0SK/6k2uy91V4EOcCTRnBPzflEC95Q=;
        b=Kr8ssbAAdPkepXAMaKIv1hoyiH8UEw5IXKJ8KOmtkadu1f0zLlnK4pWqDaUCsee+X4
         sx92eX+iNDKBKVnM0Woxu8wWz3H1kJjNsr1kgDMagNBHLHdWsnSaiGy14Gg80w1r6ZpZ
         B50bkgPxVm36xWCdYRV9KZfv0518knMjOFTS6WYcuENRq7qMMCF5C24bjq0farQ+ElBS
         j9X4qQ09LpSBYDKp+DG1s6DttXVpsyFMqayVRSaXOu6A0Ace0jZaTvAAKGSKV+txNDzU
         98koCqXqwGRbTjmpy2QNbNIXXMzIxIu67maASxiZxai3AKl0rhxhfiUgE9pSYyOit0ZD
         AeeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=OZ4DaFt4QxSyy0SK/6k2uy91V4EOcCTRnBPzflEC95Q=;
        b=e3zxtNV4lsp7OdtgArrOzWRHkHtfYr/zULjiNzpTQF+yCkHg4QE6ujE9iUfNff59N1
         OYeKXxv4YYgSWp0s3LcrijOl3aNs6SVEzsy1iGg4THji6xZCuw9LJUxtT3Y/I3jlMd+y
         qTDx5i7KLsiSq7skXFz8ZW4yZtgNWpcOdWasa79fXCophNbW8XcFiTm1A6idnrHKQ14a
         trj0GVKQNDJt+kMtLnlnRDnNcxKu1OVHe9PPhmiPpBYDlkojdcta6gbNHd29CDsNu6Aa
         otTyLmeR5M7ZvZ3ukE2v4KfEzjNWeBQi0bQMmbtPqSFuCsTJuJVmTLcO13DPN1ID9GEi
         OB2w==
X-Gm-Message-State: AOAM5319ylZlf3KoVbMkpg0cPPrb4emzmGYRKdyBZV9WP3yjAKDGhgvb
        lb+tO/FP+NWWbje89LBV6dFqxPiWGLfxx0/D+gp4/252cGojRA==
X-Google-Smtp-Source: ABdhPJxE0JKtDZ0yusnzmgC6Q+oW1VjA8yXiG52T/UIGn/BF2mmx8jeLzuVx/XbM9taCZ0ymHjiAEIXJnLTr044rkk8=
X-Received: by 2002:a65:6641:: with SMTP id z1mr1834269pgv.399.1615365300185;
 Wed, 10 Mar 2021 00:35:00 -0800 (PST)
MIME-Version: 1.0
From:   WeiGuo Ren <rwg1335252904@gmail.com>
Date:   Wed, 10 Mar 2021 16:34:48 +0800
Message-ID: <CAPy+zYVsiBspbi28VauMszHRn=a1bqLD06+bTxvvAhXN==5ixQ@mail.gmail.com>
Subject: In the ceph multisite master-zone, read ,write,delete objects, and
 the master-zone has data remaining.
To:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

In my test environment, the ceph version is v14.2.5, and there are two
rgws, which are instances of two zones, respectively rgwA
(master-zone) and rgwB (slave-zone). Cosbench reads, writes, and
deletes to rgwA. , The final result rgwA has data residue, but rgwB
has no residue.

Looking at the log later, I found that this happened:
1. When rgwA deletes the object, the rgwA instance has not yet started
datasync (or the process is slow) to synchronize the object in the
slave-zone.
2. When rgwA starts data synchronization, rgwB has not deleted the object.
In process 2, rgwA will retrieve the object from the slave-zone, and
then rgwA will enter the incremental synchronization state to
synchronize the bilog, but the bilog about the del object will be
filtered out, because syncs_trace has  master zone.

Below I did a similar reproducing operation (both in the master
version and ceph 14.2.5)
rgwA and rgwB are two zones of the same zonegroup .rgwA and rgwB is
running ( set rgw_run_sync_thread=true)
rgwA and rgwB are two zones of the same zonegroup .rgwA and rgwB is
running ( set rgw_run_sync_thread=true)
t1: rgwA set rgw_run_sync_thread=false and restart it for it to take
effect. We use s3cmd to create a bucket in rgwA. And upload an object1
in rgwA. We use s3cmd to observe whether object1 has been synchronized
in rgwB. or  look radosgw-admin bucket sync status is cauht up it. If
the synchronization has passed, proceed to the next step.
t2:rgwB set rgw_run_sync_thread=false and restart it for it to take
effect. rgwA delete object1 .
t3:rgwA set rgw_run_sync_thread=true and restart it for it to take
effect. LOOK radosgw-admin bucket sync status is cauht up it.
t4: rgwB set rgw_run_sync_thread=true and restart it for it to take
effect. LOOK radosgw-admin bucket sync status is cauht up it .
The reslut: rgwA has object1,rgwB dosen't have object1.
This URL mentioned this problem  https://tracker.ceph.com/issues/47555

Could someone can help me? or If the bucket about the rgwA instance is
not in the incremental synchronization state, can we prohibit rgwA
from deleting object1?
