Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BA3B2741D9
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Sep 2020 14:13:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726573AbgIVMNd (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Sep 2020 08:13:33 -0400
Received: from panda.postix.net ([159.69.207.141]:57406 "EHLO panda.postix.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726505AbgIVMNc (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 22 Sep 2020 08:13:32 -0400
X-Greylist: delayed 539 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Sep 2020 08:13:32 EDT
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=postix.net; s=mail;
        t=1600776269;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YlezEfpgqyX5VSnu1BrhTfLvj2WxrSlaWopYNp21yY8=;
        b=HqCX9YChMU/Ya0S1qGAy2R9FWT+HDXhjfgTzRJ5tXRAtLLsxz7tYqz5UyUxwZrMpyfwj4d
        1fTNWsClKCEYGNEaATiA44d+uq4avNG1e+j+wppBKsZk3HGKu77Uqnatqli/y8tT6e0Woh
        tAgrcz4iZc8LtUIDOHdtqMFkw2EMVp0=
Date:   Tue, 22 Sep 2020 12:04:29 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From:   tri@postix.net
Message-ID: <cc1fd8b50bf1a0ede129bf0f5f47906e@postix.net>
Subject: Re: [ceph-users] Re: Understanding what ceph-volume does, with
 bootstrap-osd/ceph.keyring, tmpfs
To:     "Janne Johansson" <icepic.dz@gmail.com>,
        "Marc Roos" <M.Roos@f1-outsourcing.eu>
Cc:     "ceph-devel" <ceph-devel@vger.kernel.org>,
        "ceph-users" <ceph-users@ceph.io>
In-Reply-To: <CAA6-MF_47O1p0Rd-_jhKfwW6s1LKYrnj7tgu07=i8NQzUzCSZQ@mail.gmail.com>
References: <CAA6-MF_47O1p0Rd-_jhKfwW6s1LKYrnj7tgu07=i8NQzUzCSZQ@mail.gmail.com>
 <H00000710017cb1c.1600697698.sx.f1-outsourcing.eu*@MHS>
Authentication-Results: ORIGINATING;
        auth=pass smtp.auth=tri@postix.net smtp.mailfrom=tri@postix.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

The key is stored in the ceph cluster config db. It can be retrieved by=
=0A=0AKEY=3D`/usr/bin/ceph --cluster ceph --name client.osd-lockbox.${OSD=
_FSID} --keyring $OSD_PATH/lockbox.keyring config-key get dm-crypt/osd/$O=
SD_FSID/luks`=0A=0ASeptember 22, 2020 2:25 AM, "Janne Johansson" <icepic.=
dz@gmail.com> wrote:=0A=0A> Den m=C3=A5n 21 sep. 2020 kl 16:15 skrev Marc=
 Roos <M.Roos@f1-outsourcing.eu>:=0A> =0A>> When I create a new encrypted=
 osd with ceph volume[1]=0A>> =0A>> Q4: Where is this luks passphrase sto=
red?=0A> =0A> I think the OSD asks the mon for it after auth:ing, so "in =
the mon DBs"=0A> somewhere.=0A> =0A> --=0A> May the most significant bit =
of your life be positive.=0A> ___________________________________________=
____=0A> ceph-users mailing list -- ceph-users@ceph.io=0A> To unsubscribe=
 send an email to ceph-users-leave@ceph.io
