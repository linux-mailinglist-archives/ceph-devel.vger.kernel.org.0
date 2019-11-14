Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D8ADFFCE23
	for <lists+ceph-devel@lfdr.de>; Thu, 14 Nov 2019 19:50:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727112AbfKNSur (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 14 Nov 2019 13:50:47 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:37198 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726592AbfKNSuq (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 14 Nov 2019 13:50:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573757445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jlBTepXx88Ma0QX6lWf6hVzOpcTRUNUg4bwctpl6eEE=;
        b=R77Wkne71+IaN49UEGWHidO2zyMfgfc19yzRiaUOMQiuUDR3RqekPp7Z9YlON9XE9+2m31
        +uTfoch259QOgQYuiFBe4WeFmqHh9dfv2mY9++2XuIpxSCu2AlDb3YMt4WwlubYpeQ+kZr
        OR1LUahCL8l1yc6VwMVQhUyKo2BCR/I=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-v505YtC8PViifjj_bBnYlQ-1; Thu, 14 Nov 2019 13:50:44 -0500
Received: by mail-qv1-f72.google.com with SMTP id d12so4736862qvj.16
        for <ceph-devel@vger.kernel.org>; Thu, 14 Nov 2019 10:50:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=9K72AbRP10B0AgTxk55QcVJ5QtCIYWwkxOjdO2QETe4=;
        b=eZvrpnibz6hbqbqgiB31MtQLMHl73Oa1Xg6JwTwUkiJwzQLscojp6vSROrF41hT4ct
         M1gdxp20qTOOyjF3EL3+eZzwRk9fW6LjDMRN90VWDaQwRnYZa04+qHSq+Z6BLlH1rLoQ
         A8CpUMD9nGLVtQVsx6BKYt2Hr4W1HpW5vLOJQeRiI2GpAHhUfuJWthlsD2Vw3j+g+INZ
         SKUvpgzXx6QxLNIHLVmV/Rhn1FoevUcWTXwdsx5OECiy16ZM/Uf8rewOVLp3bNPuaXZv
         1a4Dz6Caq98Srh+RTCJP6IYrHYy/Q7oLoG4A7fdcnyROhInRJaSjtn0ttcCxdnJidM7R
         4Fow==
X-Gm-Message-State: APjAAAXEeHNJrHiU3cgAJ24VXkcYWat8tqW/hH8R1JBquhdCE4luJb2X
        mDfb3bvOm/wKlZ/UGT/IjgKX/KYqyWYGyQ7iAKM/HHEUWHrNaa11RWGaCLmjoMDHYiqn9Lii982
        dRTcrokm+rvOufJ8diyHUt7X/GPsAiOxEC4zlrw==
X-Received: by 2002:a05:620a:6ce:: with SMTP id 14mr9176215qky.202.1573757444187;
        Thu, 14 Nov 2019 10:50:44 -0800 (PST)
X-Google-Smtp-Source: APXvYqx3amhqTnOQKxzQIM/hl35wsnB91xUaUULcBuaIj947L/1rx2qCE5TKiJol82xkqX0/VvawtxWuEHIrWqORBrA=
X-Received: by 2002:a05:620a:6ce:: with SMTP id 14mr9176183qky.202.1573757443867;
 Thu, 14 Nov 2019 10:50:43 -0800 (PST)
MIME-Version: 1.0
References: <CAKQB+ftphk7pepLdGEgckLtfj=KBp02cMqdea+R_NTd6Gwn-TA@mail.gmail.com>
 <CA+2bHPaCg4Pq-88hnvnH93QCOfgKv27gDTUjHF5rnDr6Nd2=wQ@mail.gmail.com> <CAKQB+fvUCUAeHEHwP06auyK+ZGUHZdRzTT-38xtgsSbQDjyoHQ@mail.gmail.com>
In-Reply-To: <CAKQB+fvUCUAeHEHwP06auyK+ZGUHZdRzTT-38xtgsSbQDjyoHQ@mail.gmail.com>
From:   Patrick Donnelly <pdonnell@redhat.com>
Date:   Thu, 14 Nov 2019 10:50:17 -0800
Message-ID: <CA+2bHPbw3uMLeq77XfjZfhYnYcnF-Gk+Od6UJrTiYkW+g77s4w@mail.gmail.com>
Subject: Re: [ceph-users] Revert a CephFS snapshot?
To:     Jerry Lee <leisurelysw24@gmail.com>
Cc:     Ceph Users <ceph-users@lists.ceph.com>,
        Ceph Development <ceph-devel@vger.kernel.org>
X-MC-Unique: v505YtC8PViifjj_bBnYlQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: ceph-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, Nov 13, 2019 at 6:36 PM Jerry Lee <leisurelysw24@gmail.com> wrote:
>
> On Thu, 14 Nov 2019 at 07:07, Patrick Donnelly <pdonnell@redhat.com> wrot=
e:
> >
> > On Wed, Nov 13, 2019 at 2:30 AM Jerry Lee <leisurelysw24@gmail.com> wro=
te:
> > > Recently, I'm evaluating the snpahsot feature of CephFS from kernel
> > > client and everthing works like a charm.  But, it seems that revertin=
g
> > > a snapshot is not available currently.  Is there some reason or
> > > technical limitation that the feature is not provided?  Any insights
> > > or ideas are appreciated.
> >
> > Please provide more information about what you tried to do (commands
> > run) and how it surprised you.
>
> The thing I would like to do is to rollback a snapped directory to a
> previous version of snapshot.  It looks like the operation can be done
> by over-writting all the current version of files/directories from a
> previous snapshot via cp.  But cp may take lots of time when there are
> many files and directories in the target directory.  Is there any
> possibility to achieve the goal much faster from the CephFS internal
> via command like "ceph fs <cephfs_name> <dir> snap rollback
> <snapname>" (just a example)?  Thank you!

RADOS doesn't support rollback of snapshots so it needs to be done
manually. The best tool to do this would probably be rsync of the
.snap directory with appropriate options including deletion of files
that do not exist in the source (snapshot).

--=20
Patrick Donnelly, Ph.D.
He / Him / His
Senior Software Engineer
Red Hat Sunnyvale, CA
GPG: 19F28A586F808C2402351B93C3301A3E258DD79D

