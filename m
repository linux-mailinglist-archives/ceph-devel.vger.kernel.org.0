Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0CF28340625
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Mar 2021 13:54:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231325AbhCRMyI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 Mar 2021 08:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231279AbhCRMxn (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 18 Mar 2021 08:53:43 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980F9C06174A
        for <ceph-devel@vger.kernel.org>; Thu, 18 Mar 2021 05:53:42 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id g1so1258549plg.7
        for <ceph-devel@vger.kernel.org>; Thu, 18 Mar 2021 05:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=LERvXmZUMS1jrO2Qxw6NXr2FBx2xXa4mrMXNs8tOvNM=;
        b=amgzqYQnz2KlUEv02C5G22uLiYwr/i30+Q2VjcXVjF93iVSgALySZZtgCq2ZBGWwVE
         jhWyNZ6/oEvWnYVBpCG4ptOB2b+3GeV7PyKhHoEKXDvJO1zu2aJx3f1zSMKnOcRR+qbU
         4TNpnYt1ADeFs1ACNpJ1o51iPMjPJZlgMjKED6JerYUZdrBT+GNrlA8aRDlIDsaLTkNt
         ukN0dEomPWfXMCSphGqaKwEWMvoUXmKZzACRl4T2ZwJxQz+X4Wj6i2GbUrCdVilNQVcq
         39RHfMSRmy4x1ju+ko5/B/iEQHiLzVga6pDXcnQlziUb9QoNhpdxwHqcZ82tMtChzMdM
         loZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=LERvXmZUMS1jrO2Qxw6NXr2FBx2xXa4mrMXNs8tOvNM=;
        b=b5tOHnGWW/SrghK1m9NpxzyAmoV3KDBwk5KivWTYvsEwReyRoyhZKMOe9GLLPFMhy0
         E4Wd3aIAod676F4csYqf4k5rdzdfmyyA3hB6WfSdiKpoLc0SqX4vr321uH9uYDapF++q
         zlX5Lnr8G55U1jEtRlJhKKmAqr44Jz1g+1pxNobwnbS5bIWRRM2m583AlI4WewhnOvQH
         Q6+H9j1XNNX4nJZdJdhrJKrI/dYstO42yZ5JSWpLX4qwCglCi6tKNiAuFTOfc8at4Rsj
         Zh59//9FKykANg48GumuZj/aSYfXdOpSA4los0dye/6Fb79C/IZqs5lXEVkEIsZvy0Nh
         UI4A==
X-Gm-Message-State: AOAM530mj2NwSYK9OaAMK8CAF9xvxn7ReOWkecQDRWn3tE/AEePpVInn
        GmXa6vB/3U4gYF8dhKItFtzzfJu283WQCaOHnBsrXcMclJQ5FQ==
X-Google-Smtp-Source: ABdhPJxuduDiJaBtEUmkalbmX3VilAoKq/TNfDtyj7Jv18NTUZL1RC0K/6CJ38xvzLp+WUZtvtEooXxXjNsTRaGwa9w=
X-Received: by 2002:a17:90a:f005:: with SMTP id bt5mr4335829pjb.127.1616072021997;
 Thu, 18 Mar 2021 05:53:41 -0700 (PDT)
MIME-Version: 1.0
References: <CAPy+zYWQbVojqLPdcM=Q7kEPx=ju6_efTd0-DSoryVSbiyhJLg@mail.gmail.com>
 <CAPy+zYVhfT5CYFP5=8=C6FrzvvxbGEM_ouMPUkRqUf0Db0Lmhg@mail.gmail.com>
In-Reply-To: <CAPy+zYVhfT5CYFP5=8=C6FrzvvxbGEM_ouMPUkRqUf0Db0Lmhg@mail.gmail.com>
From:   WeiGuo Ren <rwg1335252904@gmail.com>
Date:   Thu, 18 Mar 2021 20:53:28 +0800
Message-ID: <CAPy+zYUPL76Wj+fdmHX5kHt6Fv336y_G=vdhgahRdmt2EaP_KA@mail.gmail.com>
Subject: Re: rgw: Is rgw_sync_lease_period=120s set small?
To:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

radosgw-admin sync error list
[
    {
        "shard_id": 0,
        "entries": [
            {
                "id": "1_1614333890.956965_8080774.1",
                "section": "data",
                "name": "user21-bucket23:multi_master-anna.1827103.323:54",
                "timestamp": "2021-02-26 10:04:50.956965Z",
                "info": {
                    "source_zone": "multi_master-anna",
                    "error_code": 125,
                    "message": "failed to sync bucket instance: (125)
Operation canceled"
                }
            }
        ]
     }
]

I think this command should be used to determine its parameters, and
keep increasing, as long as -ECANCLE=EF=BC=88125=EF=BC=89 does not appear, =
it is
appropriate.

WeiGuo Ren <rwg1335252904@gmail.com> =E4=BA=8E2021=E5=B9=B43=E6=9C=8818=E6=
=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=887:37=E5=86=99=E9=81=93=EF=BC=9A
>
> I have an osd ceph cluster, rgw instance often appears to be renewed
> and not locked
>
> WeiGuo Ren <rwg1335252904@gmail.com> =E4=BA=8E2021=E5=B9=B43=E6=9C=8818=
=E6=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=887:35=E5=86=99=E9=81=93=EF=BC=
=9A
> >
> > In an rgw multi-site production environment, how many rgw instances
> > will be started in a single zone? According to my test, multiple rgw
> > instances will compete for the datalog leaselock, and it is very
> > likely that the leaselock will not be renewed. Is the default
> > rgw_sync_lease_period=3D120s a bit small?
