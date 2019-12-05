Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ACE86114870
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2019 22:03:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730020AbfLEVDn (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 5 Dec 2019 16:03:43 -0500
Received: from mail-lj1-f175.google.com ([209.85.208.175]:34210 "EHLO
        mail-lj1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729968AbfLEVDm (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 5 Dec 2019 16:03:42 -0500
Received: by mail-lj1-f175.google.com with SMTP id m6so5245790ljc.1
        for <ceph-devel@vger.kernel.org>; Thu, 05 Dec 2019 13:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=k+Xn4teanzP6fs/pfnKUe73rK72k2IRDJnr5VP28aDY=;
        b=bA4uNFxuj4m1n4hOyUi8ehqeCUOvNHy2NXWwTjTvOEfh9JqwbTwf5mywixKzIBzAaU
         1nKT1RF6S817OuJVBIlqFxKLf8fk5H/kiMuflHFH0XXpl+p8W52uxSSkKKN+pdJvG+kV
         RnmtNEUpwbW4i3YVeeRw3x9JcJ7somGqex4Z33U/piQjyUSKb742djk491APwm5kqY5a
         Y5JFAoH6fzR16mlZ6fHx7vPrGJDW9o6jUdBTf3YX/bwMGDOhxqEpxeNS/XF70WMDAceT
         mysSEh4Al/OPWZdQcdGONakBb0Na3aqHCCXalvDPUNQuLAlnEL+VAmLOCWTZbR/50PAg
         PnSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=k+Xn4teanzP6fs/pfnKUe73rK72k2IRDJnr5VP28aDY=;
        b=jWoNfFBCyxIxWGHOcdp/Hg3Cz9eayh8syQLGEEaIeSYjcxVaPjitW8y+xLpOxhD01y
         X9PAQzmRQg7NwFfIIuekAKxH51/IAYZx5W4A4jnpIXBzzvvsxZ5r08OK3VRTS3W6ZWja
         rkjVmTDLE/9V/7h/fveogrr1/dfxgq5gEcl7wS6w2WGz1zeRoxnOb/1XgPxQiNyjjpAd
         4f/kCyDU+9DPDfYDvRF8jG1pIsfhO+d5k4c4MdkGKez3FXs7NNGhLbtQVwCvgsQG7mq3
         DfIY3dEJKPKpf+pazF0OIB3HIoDQGBuT2+GbGH2m1iDmvIEYTV06Yn6X6d69UWWJ4A7j
         3p6A==
X-Gm-Message-State: APjAAAVMjoDldpjy31DimAK916sIedjR+Gsyh2INVFnDAM3j99+8O4Lm
        PP/4QJn7w2NESTMsV1Zg9x0=
X-Google-Smtp-Source: APXvYqy9Iqco46bqi+16isJ+4Gyn+T1RpUriCOt1LSmOjw5dQaC4VXbuSsHV2eXQ1SzL8vtSdgZElA==
X-Received: by 2002:a2e:9e8f:: with SMTP id f15mr6720400ljk.9.1575579820885;
        Thu, 05 Dec 2019 13:03:40 -0800 (PST)
Received: from [192.168.1.46] ([79.137.153.132])
        by smtp.gmail.com with ESMTPSA id v9sm5445453lfb.77.2019.12.05.13.03.39
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 05 Dec 2019 13:03:40 -0800 (PST)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3601.0.10\))
Subject: Re: device class : nvme
From:   Mike A <mike.almateia@gmail.com>
In-Reply-To: <alpine.DEB.2.21.1911212223110.21478@piezo.novalocal>
Date:   Fri, 6 Dec 2019 00:03:39 +0300
Cc:     Muhammad Ahmad <muhammad.ahmad@seagate.com>, dev@ceph.io,
        Ceph Development List <ceph-devel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <DC688FA2-0625-4B5C-99A7-2D2766C842ED@gmail.com>
References: <CAPNbX4TY5Yv31FscT0=Q5GEbFcY7M=y07y7UL9ikPhFxA+wiJw@mail.gmail.com>
 <alpine.DEB.2.21.1911212223110.21478@piezo.novalocal>
To:     Sage Weil <sage@newdream.net>
X-Mailer: Apple Mail (2.3601.0.10)
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Hello.

> 22 =D0=BD=D0=BE=D1=8F=D0=B1. 2019 =D0=B3., =D0=B2 01:25, Sage Weil =
<sage@newdream.net> =D0=BD=D0=B0=D0=BF=D0=B8=D1=81=D0=B0=D0=BB(=D0=B0):
>=20
> Adding dev@ceph.io
>   Does anybody see class 'nvme' devices in their cluster?
>=20
> Thanks!
> sage
>=20

This is my production Luminous cluster:
[root@r1flash1 ~]# ceph osd tree
ID  CLASS WEIGHT    TYPE NAME         STATUS REWEIGHT PRI-AFF=20
 -1       130.98889 root default                             =20
 -3        21.83148     host r1flash1                        =20
  0  nvme   1.81929         osd.0         up  1.00000 1.00000=20
  1  nvme   1.81929         osd.1         up  1.00000 1.00000=20
  2  nvme   1.81929         osd.2         up  1.00000 1.00000=20
  3  nvme   1.81929         osd.3         up  1.00000 1.00000=20
  4  nvme   1.81929         osd.4         up  1.00000 1.00000=20
  5  nvme   1.81929         osd.5         up  1.00000 1.00000=20
  6  nvme   1.81929         osd.6         up  1.00000 1.00000=20
  7  nvme   1.81929         osd.7         up  1.00000 1.00000=20
  8  nvme   1.81929         osd.8         up  1.00000 1.00000=20
  9  nvme   1.81929         osd.9         up  1.00000 1.00000=20
 10  nvme   1.81929         osd.10        up  1.00000 1.00000=20
 11  nvme   1.81929         osd.11        up  1.00000 1.00000=20
=E2=80=A6=20

6 nodes, 6 Intel NVMe drives per server and 2 OSD per drive.

An OSD was created with custom a script, no use LVM at all, no use =
ceph-disk or ceph-volume.
A part create an OSD in script:
<cut>
#
ID=3D$(echo "{\"cephx_secret\": \"$OSD_SECRET\"}" | ceph osd new $UUID =
-i - -n client.bootstrap-osd -k =
/var/lib/ceph/bootstrap-osd/ceph.keyring)
sudo -u ceph mkdir /var/lib/ceph/osd/ceph-$ID
ceph-authtool --create-keyring /var/lib/ceph/osd/ceph-$ID/keyring --name =
osd.$ID --add-key $OSD_SECRET
echo bluestore > /var/lib/ceph/osd/ceph-$ID/type
ln -s /dev/disk/by-partuuid/$PARTUUID /var/lib/ceph/osd/ceph-$ID/block
ln -s /dev/disk/by-partuuid/$PARTUUID_DB =
/var/lib/ceph/osd/ceph-$ID/block.db
chown ceph:ceph /var/lib/ceph/osd/ceph-$ID
chown ceph:ceph /var/lib/ceph/osd/ceph-$ID/*
chmod 600 /var/lib/ceph/osd/ceph-$ID/keyring
chmod 600 /var/lib/ceph/osd/ceph-$ID/type
ceph-osd -i $ID --mkfs --osd-uuid $UUID
chown ceph:ceph /var/lib/ceph/osd/ceph-$ID/*
<cut>

We didn=E2=80=99t use LVM for maximize IO performance and latency and =
use the script because the ceph-volume don=E2=80=99t support RAW devices =
by now.
=E2=80=94=20
Mike, runs!




