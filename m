Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD5D633CB3D
	for <lists+ceph-devel@lfdr.de>; Tue, 16 Mar 2021 03:05:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231821AbhCPCEk (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 15 Mar 2021 22:04:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbhCPCET (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 15 Mar 2021 22:04:19 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4E20C06174A
        for <ceph-devel@vger.kernel.org>; Mon, 15 Mar 2021 19:04:19 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id t18so9799550pjs.3
        for <ceph-devel@vger.kernel.org>; Mon, 15 Mar 2021 19:04:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=1PRuY3m6h5u5neSonHIwNEywTa/QJX4yZUed4ZcZq4U=;
        b=VbeGuPhH7L1GwA12RqNNMHfqyYmmZX6tQa0YOt7meKxmVZB8UWRL7MI3HOTk4LS9hF
         ZXoDsr9/Y2vVfz3G6rVdLWjc5WSzNJYIQFxE0SLblUSYp9AtpQaDJyYwur0YwrHNifvk
         0Prysl1cuj7ybCmsvTFecpKeYeH6Br/np4LghK0kmFxnRLCddsVjF/EOy1K8eMdRCHv6
         Up5CS1riVPYgDCxbUHMM4qFSuX7fz9IKYk+zWY4uvPeqh3dUm5r4+lv/keYCfmz5RdZI
         wsbKoiwysWK8TAPNucbe15+ZqxOby96GrjVmlFHVp2UxPAzz8bhMRXUQIV5M8UJMI+47
         FOWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=1PRuY3m6h5u5neSonHIwNEywTa/QJX4yZUed4ZcZq4U=;
        b=m0ThPGAJTpVrTKJlWygmzkJ24VhPRzTssyKO8bI+w8mb/XndhsRBzHg8mv7/CStqsr
         0GvUwHONG1DdE895r7XNEFZdZRqwybr+HLcvoF/xd6TAam666WoLPTHLEQ4cP09OgSpT
         yZUH/zlb3KA/F0rcul8rgerYRylvpeh3eGSrHPOYhINg6uVMvAxqw16Hzs/nPvG/1ukd
         4TN74Us+goiKd88mUidcHIt8ZTviJbbE4PQE+3kZ4K8bpGTl9co+RDumInR4PByv2h5f
         GmxvvsPsKOIraOYqqoX8bFlQy3gjyqQZxOjq25EMAdffmdO4O2bfdi3xodXsZFfLbN7y
         p+zQ==
X-Gm-Message-State: AOAM532XpAEBuo+PaG41i2fAAa4KSnA9EcdNzT9rvS2Q5YrOVzTw5OR1
        ZzNd8KTwe79kg+qCyyhMjGvGOwtd9eTDKHE79BEyJaczCPU=
X-Google-Smtp-Source: ABdhPJw7sLXb9LvBLsjf5OxcfGtr5iLPsSXS8fOyBpi6L+NnHSfajwUZGhiZnPap1qDxOUaZIC14bc++UTRd5Jzp7vg=
X-Received: by 2002:a17:90a:f005:: with SMTP id bt5mr2240303pjb.127.1615860258747;
 Mon, 15 Mar 2021 19:04:18 -0700 (PDT)
MIME-Version: 1.0
References: <CAPy+zYVsiBspbi28VauMszHRn=a1bqLD06+bTxvvAhXN==5ixQ@mail.gmail.com>
In-Reply-To: <CAPy+zYVsiBspbi28VauMszHRn=a1bqLD06+bTxvvAhXN==5ixQ@mail.gmail.com>
From:   WeiGuo Ren <rwg1335252904@gmail.com>
Date:   Tue, 16 Mar 2021 10:04:05 +0800
Message-ID: <CAPy+zYW17u=5mnyx33jODXdMyEQ2dnHWRUHtVW_xmu9+zmSnVA@mail.gmail.com>
Subject: Re: In the ceph multisite master-zone, read ,write,delete objects,
 and the master-zone has data remaining.
To:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Do we need to solve this problem?

WeiGuo Ren <rwg1335252904@gmail.com> =E4=BA=8E2021=E5=B9=B43=E6=9C=8810=E6=
=97=A5=E5=91=A8=E4=B8=89 =E4=B8=8B=E5=8D=884:34=E5=86=99=E9=81=93=EF=BC=9A
>
> In my test environment, the ceph version is v14.2.5, and there are two
> rgws, which are instances of two zones, respectively rgwA
> (master-zone) and rgwB (slave-zone). Cosbench reads, writes, and
> deletes to rgwA. , The final result rgwA has data residue, but rgwB
> has no residue.
>
> Looking at the log later, I found that this happened:
> 1. When rgwA deletes the object, the rgwA instance has not yet started
> datasync (or the process is slow) to synchronize the object in the
> slave-zone.
> 2. When rgwA starts data synchronization, rgwB has not deleted the object=
.
> In process 2, rgwA will retrieve the object from the slave-zone, and
> then rgwA will enter the incremental synchronization state to
> synchronize the bilog, but the bilog about the del object will be
> filtered out, because syncs_trace has  master zone.
>
> Below I did a similar reproducing operation (both in the master
> version and ceph 14.2.5)
> rgwA and rgwB are two zones of the same zonegroup .rgwA and rgwB is
> running ( set rgw_run_sync_thread=3Dtrue)
> rgwA and rgwB are two zones of the same zonegroup .rgwA and rgwB is
> running ( set rgw_run_sync_thread=3Dtrue)
> t1: rgwA set rgw_run_sync_thread=3Dfalse and restart it for it to take
> effect. We use s3cmd to create a bucket in rgwA. And upload an object1
> in rgwA. We use s3cmd to observe whether object1 has been synchronized
> in rgwB. or  look radosgw-admin bucket sync status is cauht up it. If
> the synchronization has passed, proceed to the next step.
> t2:rgwB set rgw_run_sync_thread=3Dfalse and restart it for it to take
> effect. rgwA delete object1 .
> t3:rgwA set rgw_run_sync_thread=3Dtrue and restart it for it to take
> effect. LOOK radosgw-admin bucket sync status is cauht up it.
> t4: rgwB set rgw_run_sync_thread=3Dtrue and restart it for it to take
> effect. LOOK radosgw-admin bucket sync status is cauht up it .
> The reslut: rgwA has object1,rgwB dosen't have object1.
> This URL mentioned this problem  https://tracker.ceph.com/issues/47555
>
> Could someone can help me? or If the bucket about the rgwA instance is
> not in the incremental synchronization state, can we prohibit rgwA
> from deleting object1?
