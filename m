Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF0283CB7DA
	for <lists+ceph-devel@lfdr.de>; Fri, 16 Jul 2021 15:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239879AbhGPNa5 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 16 Jul 2021 09:30:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239391AbhGPNa5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 16 Jul 2021 09:30:57 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD95FC06175F
        for <ceph-devel@vger.kernel.org>; Fri, 16 Jul 2021 06:28:01 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id d9so10545711ioo.2
        for <ceph-devel@vger.kernel.org>; Fri, 16 Jul 2021 06:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=558LhAZNzdgXANWhHBIVHbkkjqS4lhyXoVDo+SyKu6Y=;
        b=pHV3PRF2bGhu+YwxYqzCiyMwV/ssS30bNxzR2O+qUqaePZn7/0/PQwGDUSegCyfIce
         KqIxpEAoMnE7UZB0qF4uNUzm5NW0KRwKZm0HE+uAk9ggOGDTkMKzdjnAwyYKUxk8jCli
         FSC/GONbeAMQ8nb6n3/BZQuhuw28xtzBp68qohnsTts05T/UbsiyiYaw8MxRwL9mYB0L
         yACbnsn9STLLErC6vlQbXshUkUi0nkM39YR3drhXdtV8/ct5CGfm4C7pUEIOYzOUhKYE
         2MgL1A3457g5EjQGE0coJw0m3mnCF40RkVHOD+cCN6Pkk5iDYHkOBXYU9E7Y6V9Owimv
         V4lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=558LhAZNzdgXANWhHBIVHbkkjqS4lhyXoVDo+SyKu6Y=;
        b=k86Np0P69cNPBnCK3OLu1C9nyY1hUHhJiidhxPGu1UCMTJdrf7qK81SLdg45k/ynsa
         HLk/iB8z9bDwlVR3j1fOv8uIDA+WwjLx0jKwBfZXqvP6jlpFbAoz4lX7W+NgDfdgTegm
         QD2AncAwkzGBByOoeJO6rDvomfWiJKONCvV4vK9w1eED5qAZfMA2KTmAXUysX0gp09KL
         0KlBR+0UGIzYkD1TB/ww7VUx4mHofdWi1+pnuEiy2qsJQOKUNZ74w93St7QqxmVS+oW9
         qcFCNW9xJeQrIwyplypaXJiIoi967WNnDDKoHuxhJOSRQIS+/cjRMQjd2SwnBNpaY997
         GcfQ==
X-Gm-Message-State: AOAM532WSCG16x98211qBiem+hhVeUDZqkQZgbXRGegtRutXbWESUUzI
        HB5uP51K0xlDNWsi9MDi9aRKXyqgDhVRJ6s4q0I=
X-Google-Smtp-Source: ABdhPJxG3mMixCFx2GroTU+TU5ZoTyiw8fWOPeiFMAMTIV51r6fiIJ2Y8Xk08zNTgIDi6jvWjzXBB+cyvhphHV1lu2Y=
X-Received: by 2002:a02:9109:: with SMTP id a9mr9077335jag.93.1626442081382;
 Fri, 16 Jul 2021 06:28:01 -0700 (PDT)
MIME-Version: 1.0
References: <CAOdVJi3EQ=-3PeX6LvxMVqhpFZVE4TPiPu+H1HoAmiTpEwvh=A@mail.gmail.com>
In-Reply-To: <CAOdVJi3EQ=-3PeX6LvxMVqhpFZVE4TPiPu+H1HoAmiTpEwvh=A@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Fri, 16 Jul 2021 15:27:28 +0200
Message-ID: <CAOi1vP8CLJYBR0hBKOGBGc62W1f+8vWQTJ2uh=BhNJBx7Wb0XQ@mail.gmail.com>
Subject: Re: the issue of rgw sync concurrency
To:     star fan <jfanix@gmail.com>
Cc:     dev <dev@ceph.io>, Casey Bodley <cbodley@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jul 15, 2021 at 2:25 PM star fan <jfanix@gmail.com> wrote:
>
> We found some unnormal status of sync status when running multiple
> rgw(15.2.14) multisize sync, then I dig into the codes about rgw sync.
> I think there is a issues of rgw sync concurrency implementation if I
> understand correctly.
> The implementation of  the critical process which we want it run once,
> which steps are as below:
> 1. read shared status object
> 2. check status
> 3. lock status
> 4. critical process
> 5. store status
> 6. unlock
>
> It is a problem in concurrent case that  the critical process would
> run multiple times because it uses old status, thus it makes no sense.
> The steps should be as below
> 1. read shared status object
> 2. check status
> 3. lock status
> 4. read and check status again
> 5. critical process
> 6. store status
> 7. unlock
>
> one example as below
> do {
> r =3D run(new RGWReadSyncStatusCoroutine(&sync_env, &sync_status));
> if (r < 0 && r !=3D -ENOENT) {
> tn->log(0, SSTR("ERROR: failed to fetch sync status r=3D" << r));
> return r;
> }
>
> switch ((rgw_meta_sync_info::SyncState)sync_status.sync_info.state) {
> case rgw_meta_sync_info::StateBuildingFullSyncMaps:
> tn->log(20, "building full sync maps");
> r =3D run(new RGWFetchAllMetaCR(&sync_env, num_shards,
> sync_status.sync_markers, tn));
>
> And there is no deletion of omapkeys after finishing sync entry in
> full_sync process, thus full_sync would run multiple times in
> concurrent case.
>
> It has  no importance impact on data sync because bucket syncing is
> idempotence=EF=BC=8Cbut no metadata sync

Moving to dev@ceph.io and adding Casey.

Thanks,

                Ilya
