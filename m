Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C232E20C5B6
	for <lists+ceph-devel@lfdr.de>; Sun, 28 Jun 2020 06:23:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726084AbgF1EXr (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sun, 28 Jun 2020 00:23:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725988AbgF1EXq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sun, 28 Jun 2020 00:23:46 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EFAAC061794
        for <ceph-devel@vger.kernel.org>; Sat, 27 Jun 2020 21:23:46 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id v6so136569iob.4
        for <ceph-devel@vger.kernel.org>; Sat, 27 Jun 2020 21:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nj7z2p8V9TM3ZqsJpXR82bspyfrx0bzfcu7b/n0ERnk=;
        b=dj7Pp2nosWhKmXhAQrZBcGarbllbk9MbkJTUjk8K0i8ATN0qmfcBc/oDA2FDpV1lDV
         sPT1EOTZSHJ7OY/h0S0qVop6z1JxfDIUj+zKcHUyM/7B8a2kOxfO+F5MTN2Sh98a9NuW
         3WbHWyvSRlkJ+SB6JWc5rz41fwj/rw4nAyK090xB7R9g7QhN2a+sTSJGOhb5gsrgZ7eV
         UK0Qj/dNC/PyN3A10GuBPLZg8k3LILo9kCPW/CxtivgaTNis84BpGo3V7Y82Fe5aU5nP
         Ji/QNoX/gR5IvC46TjA3CyMctdcPFrmYjWs92i7gu8uif1sexs+VSnlr08CR7wzYJ5Pk
         OprA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nj7z2p8V9TM3ZqsJpXR82bspyfrx0bzfcu7b/n0ERnk=;
        b=dKrkEikRA70thkkfsvHinPFXFUaoUY5RBgaJ62yQuEozZZTKt4UD1YrtoU1jfabQMj
         tqrTg9awNiKh3jH81VsMmEpJ+eNAbTE4EGLJdLb6k47EAhj0wbW8ZtwzaEiN1LfywkDp
         0CqZhOITt7FsDh6p4Kzz5SqbFZHe7dofSfraf+LST5tVZtAl/4ypHlj+p2RMesmzSm03
         hkKcQnyRlZmw4uDnKzPawE3xSmNfpMZadkp6pJrVHx0jwZ2loUjeH27UzKE/O3/KA99Y
         ckz/vD7nBCPiLVhVg1yYNO5JfL7Xv6kMHVv77pZ4SWSaScijFWw47NeR/UGL3UU1t9mz
         2jLA==
X-Gm-Message-State: AOAM530nK2ltzK+AlcXZOrPFfSPoKfFAzwQ8GTK5bJuELCx/K7gBbD9v
        64BX3Wsoj7YDGJyVJU2UY/JY77UrRi4PGqAYPQw=
X-Google-Smtp-Source: ABdhPJz2dqhofL1boo9+aKkRpWgL55ZicdWsNLuLX/YiyaMPDqMm+m7RbWHJRcp0pROzDp/i0+A25MTLicWEVK7Ogh0=
X-Received: by 2002:a02:c043:: with SMTP id u3mr11618299jam.39.1593318225890;
 Sat, 27 Jun 2020 21:23:45 -0700 (PDT)
MIME-Version: 1.0
References: <CALZt5jy7G3e7+bibmNXeqxsRuoSwwE-U7G=cu5KvwAbsEiAmKQ@mail.gmail.com>
In-Reply-To: <CALZt5jy7G3e7+bibmNXeqxsRuoSwwE-U7G=cu5KvwAbsEiAmKQ@mail.gmail.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Sun, 28 Jun 2020 06:23:53 +0200
Message-ID: <CAOi1vP8Ppr300Ag7FvRRg6mY1+4+dvXUkLsD4CYogv9aEsZbkQ@mail.gmail.com>
Subject: Re: why cephfs kernel module does not support fallocate with default mode?
To:     Ning Yao <zay11022@gmail.com>
Cc:     dev <dev@ceph.io>, "Yan, Zheng" <zyan@redhat.com>,
        "Yan, Zheng" <ukernel@gmail.com>,
        ceph-devel <ceph-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Sat, Jun 27, 2020 at 6:02 PM Ning Yao <zay11022@gmail.com> wrote:
>
> Hi, all
>
> I find the in cephfs kernel module fs/ceph/file.c, the function ceph_fall=
ocate return -EOPNOTSUPP=EF=BC=8Cwhen mode !=3D (FALLOC_FL_KEEP_SIZE | FALL=
OC_FL_PUNCH_HOLE)=E3=80=82
>
> Recently=EF=BC=8Cwe try to use cephfs but need supporting fallocate sysca=
ll to generate the file writing not failed after reserved space. But we fin=
d the cephfs kernel module does not support this right now. Can anyone expl=
ain why we don't implement this now?

It used to be supported (as in it wasn't rejected with EOPNOTSUPP),
but never actually worked.  There is no easy way to preallocate/reserve
space in the cluster without explicitly zeroing it.  If the space isn't
actually reserved, subsequent writes could fail with ENOSPC which would
violate POSIX and break applications, so we chose to disable it.

>
> We also find out ceph-fuse can support the falllocate syscall but endwith=
 a pool writing performance vs cephfs kernel mount. There is a large perfor=
mance gap under fio.cfg below:

ceph-fuse is broken in the same way and it should be disabled there
as well.

Thanks,

                Ilya
