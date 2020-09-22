Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAFA22746C8
	for <lists+ceph-devel@lfdr.de>; Tue, 22 Sep 2020 18:39:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgIVQjM (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 22 Sep 2020 12:39:12 -0400
Received: from mx.byet.net ([82.163.176.250]:47266 "EHLO mx.byet.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726558AbgIVQjL (ORCPT <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 22 Sep 2020 12:39:11 -0400
X-Greylist: delayed 591 seconds by postgrey-1.27 at vger.kernel.org; Tue, 22 Sep 2020 12:39:10 EDT
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mx.byet.net (Postfix) with ESMTP id CE75722C14BA;
        Tue, 22 Sep 2020 20:29:16 +0400 (MSD)
Received: from mx.byet.net ([127.0.0.1])
        by localhost (mx.byet.net [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id 95Enx8Ny0jg4; Tue, 22 Sep 2020 20:29:16 +0400 (MSD)
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mx.byet.net (Postfix) with ESMTP id 6807E22C24BE;
        Tue, 22 Sep 2020 20:29:16 +0400 (MSD)
DKIM-Filter: OpenDKIM Filter v2.10.3 mx.byet.net 6807E22C24BE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ifastnet.com;
        s=45AB4D8C-726C-11E6-A1AA-0624B6FC591E; t=1600792156;
        bh=Kh8yR/LgYrJum1y/x0ojmSj6aEAVeDuGfKnAJWP/0II=;
        h=From:Mime-Version:Date:Message-Id:To;
        b=Ey+HzQiZMv748bBpulTu3ev5udMe4j3pLCaN7G+8evMQbUbQgJVgBgS+QYPw4JWpw
         rwefD5GUG8opiFI66pwt60dwcojjvWPX4nPkaIwAKGJbMftBc8RWQeZKXqlg9P5nrs
         YIjrE1GaKWRdhag9hWO00yE7KCVImcXTUU01N7zRC2jKmxSLMFhmm4l0gkrLJm3vy5
         x3GqPu/d/aXiMDNu/W5TGHeD/JL/vJ0FZbREbt61WDVxz3t239aAgr4x4z0XTT4yZA
         g6K9rQ3qN+IRYi99khTaLeNc86rbgh13dBDVSJ5f+6G/9OnfPoq2Xnvnr0hqi0Hpqh
         NIcuLyGvVSpzQ==
Received: from mx.byet.net ([127.0.0.1])
        by localhost (mx.byet.net [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id zIo5sKZIjK6M; Tue, 22 Sep 2020 20:29:16 +0400 (MSD)
Received: from localhost.localdomain (unknown [213.205.241.242])
        by mx.byet.net (Postfix) with ESMTPSA id 41DA522C14BA;
        Tue, 22 Sep 2020 20:29:16 +0400 (MSD)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
From:   Kevin Myers <response@ifastnet.com>
Mime-Version: 1.0 (1.0)
Subject: Re: [ceph-users] Re: Understanding what ceph-volume does, with bootstrap-osd/ceph.keyring, tmpfs
Date:   Tue, 22 Sep 2020 17:29:15 +0100
Message-Id: <856E0EEA-F867-48D4-9A2B-57182BE28208@ifastnet.com>
References: <cc1fd8b50bf1a0ede129bf0f5f47906e@postix.net>
Cc:     Janne Johansson <icepic.dz@gmail.com>,
        Marc Roos <M.Roos@f1-outsourcing.eu>,
        ceph-devel <ceph-devel@vger.kernel.org>,
        ceph-users <ceph-users@ceph.io>
In-Reply-To: <cc1fd8b50bf1a0ede129bf0f5f47906e@postix.net>
To:     tri@postix.net
X-Mailer: iPad Mail (18A373)
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Tbh ceph caused us more problems than it tried to fix ymmv good luck


> On 22 Sep 2020, at 13:04, tri@postix.net wrote:
>=20
> =EF=BB=BFThe key is stored in the ceph cluster config db. It can be retrie=
ved by
>=20
> KEY=3D`/usr/bin/ceph --cluster ceph --name client.osd-lockbox.${OSD_FSID} -=
-keyring $OSD_PATH/lockbox.keyring config-key get dm-crypt/osd/$OSD_FSID/luk=
s`
>=20
> September 22, 2020 2:25 AM, "Janne Johansson" <icepic.dz@gmail.com> wrote:=

>=20
>> Den m=C3=A5n 21 sep. 2020 kl 16:15 skrev Marc Roos <M.Roos@f1-outsourcing=
.eu>:
>>=20
>>> When I create a new encrypted osd with ceph volume[1]
>>>=20
>>> Q4: Where is this luks passphrase stored?
>>=20
>> I think the OSD asks the mon for it after auth:ing, so "in the mon DBs"
>> somewhere.
>>=20
>> --
>> May the most significant bit of your life be positive.
>> _______________________________________________
>> ceph-users mailing list -- ceph-users@ceph.io
>> To unsubscribe send an email to ceph-users-leave@ceph.io
> _______________________________________________
> ceph-users mailing list -- ceph-users@ceph.io
> To unsubscribe send an email to ceph-users-leave@ceph.io

