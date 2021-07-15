Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03F563C9DD5
	for <lists+ceph-devel@lfdr.de>; Thu, 15 Jul 2021 13:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230270AbhGOLjT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 15 Jul 2021 07:39:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbhGOLjT (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 15 Jul 2021 07:39:19 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96C57C06175F
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jul 2021 04:36:25 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id b5-20020a17090a9905b029016fc06f6c5bso3905849pjp.5
        for <ceph-devel@vger.kernel.org>; Thu, 15 Jul 2021 04:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=9eGeYXp/UXXoFJuDLlKUa9wRvKjdU3VoCh+M6LYoqXY=;
        b=Li6kxl9gOe5OX52jY7Z0gah0aA83Rg9iRw++dymlLOgrcaMlWNaWfLFaufLWN3qSLu
         5LAH/TMGa54RyMx6KKi/LF1YG9bLNW1auWL3fSBNvUlPwjQGwVpUH9GhoLDU1yxmG0Mo
         UE9qejIsB+OznmS7odp7OYyde2nzCgAxEmj56wAb2xqiAJs1aDJldLQJob7UI6aPQkTx
         /GdGbtvASl29o132XA7BwDNvWbbZ/4iutXUs1d4+L/BkflfnBEotDhqoXhte4OQ9M9sk
         qio5KDGuro9sammxf6qs1Zfo3O760giCDI22Kvr7+GMhvsYbkdhm4LciNwVcNU6pQ9Cc
         n1EQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=9eGeYXp/UXXoFJuDLlKUa9wRvKjdU3VoCh+M6LYoqXY=;
        b=UkhTbWhgeQdlLf+4Dqv5sserXWYykQ/6EuDmpWLjFXe3shms4dt5MWpS4LU/QbuCEs
         97XfWms+eRckl+PqXMtJ0vjipHERXyURwFkrkr2kFc/Tdfmbl5Qp3E6Kv5TevORAD9rh
         1Xp97cyw2RghFYu9P4haQrVmHKOHJdW0gnEuklOqNYHwvzi6Tt3eloFTmD2s2Fm62aYz
         4kDcHFGGLw9fJMfav2cQ1bd0j0im5kt2y3Ztow3bEAUI6ZJjumSSlBTAi1LMks+mz9cm
         BA5rvjonuwtnBqXf2//ADfB/vfVmpxfp100TnVqx4CyxJMV6QTfevnaP9olMuIq43IDv
         JkNw==
X-Gm-Message-State: AOAM530EESg7U/ObJYB7SAeRGoWtlxsYWDuLENbHUZ+dxTjY61fYmGOz
        kZ0uCL9kmvgIJj1jBPI10VJyhzDmg4/eF9ZW9tmf3sAlWoGQ6Q==
X-Google-Smtp-Source: ABdhPJy1EUJZHMpgRSNmCRWLza5cA3ZUQqUns1nk/vs2B6kA9HQ3zjY/sxX5MlLEtoS7u4J8UUnSo53HkETpfhtobUA=
X-Received: by 2002:a17:90a:fd14:: with SMTP id cv20mr3867810pjb.98.1626348984654;
 Thu, 15 Jul 2021 04:36:24 -0700 (PDT)
MIME-Version: 1.0
From:   star fan <jfanix@gmail.com>
Date:   Thu, 15 Jul 2021 19:36:13 +0800
Message-ID: <CAOdVJi3EQ=-3PeX6LvxMVqhpFZVE4TPiPu+H1HoAmiTpEwvh=A@mail.gmail.com>
Subject: the issue of rgw sync concurrency
To:     Ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

We found some unnormal status of sync status when running multiple
rgw(15.2.14) multisize sync, then I dig into the codes about rgw sync.
I think there is a issues of rgw sync concurrency implementation if I
understand correctly.
The implementation of  the critical process which we want it run once,
which steps are as below:
1. read shared status object
2. check status
3. lock status
4. critical process
5. store status
6. unlock

It is a problem in concurrent case that  the critical process would
run multiple times because it uses old status, thus it makes no sense.
The steps should be as below
1. read shared status object
2. check status
3. lock status
4. read and check status again
5. critical process
6. store status
7. unlock

one example as below
do {
r =3D run(new RGWReadSyncStatusCoroutine(&sync_env, &sync_status));
if (r < 0 && r !=3D -ENOENT) {
tn->log(0, SSTR("ERROR: failed to fetch sync status r=3D" << r));
return r;
}

switch ((rgw_meta_sync_info::SyncState)sync_status.sync_info.state) {
case rgw_meta_sync_info::StateBuildingFullSyncMaps:
tn->log(20, "building full sync maps");
r =3D run(new RGWFetchAllMetaCR(&sync_env, num_shards,
sync_status.sync_markers, tn));

And there is no deletion of omapkeys after finishing sync entry in
full_sync process, thus full_sync would run multiple times in
concurrent case.

It has  no importance impact on data sync because bucket syncing is
idempotence=EF=BC=8Cbut no metadata sync
