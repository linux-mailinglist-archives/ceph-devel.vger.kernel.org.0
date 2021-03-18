Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82355340B12
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Mar 2021 18:11:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231995AbhCRRKb (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 18 Mar 2021 13:10:31 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:23960 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232216AbhCRRK1 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 18 Mar 2021 13:10:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1616087424;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2OINpMVQBvtOIEMSvFRT/blX5mHdm75+1aKbMZd05RE=;
        b=VG3oIAD64OQzwC5nclnZkZtztCkUnh3ae0mtWVXOOpSmHsrw1Kse7M8kRl3zSQHksgvjpP
        OVcLLZgYrgzX5g6s+MHBSb1aa/vFy6d54gRJL3bHs7viqClyBUsf3j7jk664reN+I/eiML
        a/GoEo+QaCfwdR9mBsai9MTQ628/PZM=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-455-xsESDnfnMdyA_JASdgRK8g-1; Thu, 18 Mar 2021 13:10:19 -0400
X-MC-Unique: xsESDnfnMdyA_JASdgRK8g-1
Received: by mail-wm1-f69.google.com with SMTP id c7so12115483wml.8
        for <ceph-devel@vger.kernel.org>; Thu, 18 Mar 2021 10:10:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2OINpMVQBvtOIEMSvFRT/blX5mHdm75+1aKbMZd05RE=;
        b=m1eqy1DxJVxfajKkNzWFSgE62DmRdS/UUhnL1LeyhY5C4JyThV8h2KOYNgUOEKzwZj
         FrqTd/vex+Oshwpwy6teBlzyDr5uKXPumnvjRs/Qvm4X5WEvVW3g5wiGCydU/XOH8hie
         MToUOK3JsprUVZBS+7szSvM4XQX+31sSqRxFG7lczqXc5jyUXBXPAYMBN9vukdR6Ainz
         Lt05Ipzm5dB3GWcv+i1F0QCb+Y+IgIjeTG6wiOcuDk0/jRwdYPOsTPMezLVQ+wE4mxcz
         MtAI6vOhKbt7TAtXOA8oMvlAi4DKQHDyRjgqDp3IuT7XCgLlY5FLimfW7h5uFf6ahyeO
         F/bA==
X-Gm-Message-State: AOAM530pLNOpuEitgBDLVy1Bz1DcBIFbg7zQsrLQoFRnDonFGQd8TrKy
        QS7fFmwnKxzJOGRrnCnXOJRSx8QoxlLUHF+LpfZsJNXO4VuouTQlxCVV+WupEhxHjjE1FZzMwMj
        Mj2bmWEKH8oouS3QGHWM0EfTHaF2N6PDBIyqs7w==
X-Received: by 2002:a05:6000:124f:: with SMTP id j15mr257187wrx.263.1616087417825;
        Thu, 18 Mar 2021 10:10:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJx8Ncrl4uNxU3HqojFyTtknxftTyqxe51NJ19An90Btr1dN+NXVumBNEM8NRali8Z6WMtbv9sQuwr7VrFNl5xs=
X-Received: by 2002:a05:6000:124f:: with SMTP id j15mr257181wrx.263.1616087417693;
 Thu, 18 Mar 2021 10:10:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAPy+zYWQbVojqLPdcM=Q7kEPx=ju6_efTd0-DSoryVSbiyhJLg@mail.gmail.com>
 <CAPy+zYVhfT5CYFP5=8=C6FrzvvxbGEM_ouMPUkRqUf0Db0Lmhg@mail.gmail.com> <CAPy+zYUPL76Wj+fdmHX5kHt6Fv336y_G=vdhgahRdmt2EaP_KA@mail.gmail.com>
In-Reply-To: <CAPy+zYUPL76Wj+fdmHX5kHt6Fv336y_G=vdhgahRdmt2EaP_KA@mail.gmail.com>
From:   Casey Bodley <cbodley@redhat.com>
Date:   Thu, 18 Mar 2021 13:09:37 -0400
Message-ID: <CAF-p1-LNe-nmu55jd2_vvXqzadwU0qv60r6=XmA6hF58BpDXOA@mail.gmail.com>
Subject: Re: rgw: Is rgw_sync_lease_period=120s set small?
To:     WeiGuo Ren <rwg1335252904@gmail.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Mar 18, 2021 at 8:55 AM WeiGuo Ren <rwg1335252904@gmail.com> wrote:
>
> radosgw-admin sync error list
> [
>     {
>         "shard_id": 0,
>         "entries": [
>             {
>                 "id": "1_1614333890.956965_8080774.1",
>                 "section": "data",
>                 "name": "user21-bucket23:multi_master-anna.1827103.323:54=
",
>                 "timestamp": "2021-02-26 10:04:50.956965Z",
>                 "info": {
>                     "source_zone": "multi_master-anna",
>                     "error_code": 125,
>                     "message": "failed to sync bucket instance: (125)
> Operation canceled"
>                 }
>             }
>         ]
>      }
> ]
>
> I think this command should be used to determine its parameters, and
> keep increasing, as long as -ECANCLE=EF=BC=88125=EF=BC=89 does not appear=
, it is
> appropriate.
>
> WeiGuo Ren <rwg1335252904@gmail.com> =E4=BA=8E2021=E5=B9=B43=E6=9C=8818=
=E6=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=887:37=E5=86=99=E9=81=93=EF=BC=
=9A
> >
> > I have an osd ceph cluster, rgw instance often appears to be renewed
> > and not locked
> >
> > WeiGuo Ren <rwg1335252904@gmail.com> =E4=BA=8E2021=E5=B9=B43=E6=9C=8818=
=E6=97=A5=E5=91=A8=E5=9B=9B =E4=B8=8B=E5=8D=887:35=E5=86=99=E9=81=93=EF=BC=
=9A
> > >
> > > In an rgw multi-site production environment, how many rgw instances
> > > will be started in a single zone?

it depends on the scale, but i'd guess anywhere from 2-8?

if the zone is serving clients (not just DR), it can make sense to
dedicate some of the rgws to clients (by setting
rgw_run_sync_thread=3D0, and not including their endpoints in the zone
configuration), and others just to sync. so i think it's easy enough
to control how many gateways are contending for these leases

you can raise the lease period, but that means it will take longer for
sync to recover from a radosgw shutdown/restart. the shard locks it
held will take longer to expire, preventing other gateways from
resuming sync on those shards


> > > According to my test, multiple rgw
> > > instances will compete for the datalog leaselock, and it is very
> > > likely that the leaselock will not be renewed. Is the default
> > > rgw_sync_lease_period=3D120s a bit small?
>

