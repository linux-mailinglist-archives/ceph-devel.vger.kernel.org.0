Return-Path: <ceph-devel+bounces-4194-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 5ED4DCCB64E
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Dec 2025 11:33:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 34C443037E1B
	for <lists+ceph-devel@lfdr.de>; Thu, 18 Dec 2025 10:31:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64511332EA1;
	Thu, 18 Dec 2025 10:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fw8J0xoz"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6CFB3321BA
	for <ceph-devel@vger.kernel.org>; Thu, 18 Dec 2025 10:30:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766053858; cv=none; b=ieLuwj5zoJuy9FOuDs7M6aWTy89D0hKez0I0Kcb4P6JicTxKi/e738g2/a1MGSrRDCTaGI96G3s4o6JB3wYb2XhBUjv3x7BZ4Nc+Z427un+r3GZ3T1reXhVsoqHeDH2xqdReQeaN1LEVQyRHLSFEFkOtH1XdzT8r6WRja4NSMlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766053858; c=relaxed/simple;
	bh=coLA1gMnueOdWW2y3zkfSAuSFNiYs3kPhCnOPTkxuf0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FQSyRrO1Ro+pBdtvgn7u2eGk56TUpoYIP3Qt1LW4MnQUdKQ4EECP/mVk5VMM5+la2OMnLhTdG43vohrDjxPIzGKytcrV/GDEwERoFzrXIbNo5nx2rdrfHrO2WSSBvXNhn3umd30dMeMnOjwX1bVp03ksYxNXrsoW3ZEbWFt+ePo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fw8J0xoz; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-bd1b0e2c1eeso362204a12.0
        for <ceph-devel@vger.kernel.org>; Thu, 18 Dec 2025 02:30:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766053856; x=1766658656; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qfx0RSNVAivkH6E1CctvNqx0dWYRIEIIvPaPiHNi3os=;
        b=fw8J0xozTCj++5U+USmL9K9+0AUaiUN2hPOITMXq8m9FDVCk24dJr5HbPJJIaIeuo2
         GBkeNu+UBMxKAN1vFx560UjWjN5jSek70QEjCB6iHApc20D9n1GpsTXkuP6WbxAiwjQm
         YOyWM/pO4/vFQsGQxhUiVD/u+VwS0pJsXVI2ZPrwTr3wnzrfwSb03EcX+SAfTcd7zvr9
         Sk4/MzA7w9300n3KBuradHKIoPsACOm3cDCSElhI+9y+vYbs8gqo3ZFvi7ZBFtg3TIe5
         clNcMzSdqnfWxs2gLWPTrYGJlgm5rvnUVFGXSraUzUrcPuUmv3e8F6XpcwVeFYCsQ42r
         GxFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766053856; x=1766658656;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=qfx0RSNVAivkH6E1CctvNqx0dWYRIEIIvPaPiHNi3os=;
        b=WUvbVO8079hLjTQiTuTL8StxEZs2HFz6z/jGesTka1JC04N5iBCxGXucgr4jq6tPxH
         FBAblawWRuwVlVZqfAxBkQf0KSGfveRI+JksLKEtirA74/DdBwLROKEc1TdLz9oSNPYz
         Ja2V9+q7dmNaidx5lwT8G6FYIqXovZj79+mMYn3q1flf3EUc3UHXJKwHsUEEhRCWfUnM
         Vu0JRjs2SHOngOGRJPrNVzuUnn1q2OOOz6lH2h9A+s7uoB39rpJtFuuhtTcMBTgoxeco
         xWfVgRs8nmzqo4jORscnGOXaiXF9A4/ZoeCkjNI3E0RwstFEu4xfKSSQOV8z6Oh+CAt7
         cJNg==
X-Forwarded-Encrypted: i=1; AJvYcCVDzcVvKshAfpPgAomWmQg3PzV8id/F9YcVu1UDuQJ1wCX2e1DZkPu4lLO2UcDHUVxWQYSgSX4dMaYB@vger.kernel.org
X-Gm-Message-State: AOJu0Yxb9xLazuUoOVCJJtHXzbt5YFDnqwMjIMg1mJnQfjOgMJ54A0pj
	WPLvGNfh9RcZ2RG/dMBzz50/9H8Sc5s1kEYKhedVYyjUxs2Sip3Axnd5UZrFVrrtklU3AQzTyN/
	DrkWBNRrQI42EinbKyRK/FaZAqcSEDA4=
X-Gm-Gg: AY/fxX68yZvP9uMZc10COccce5Xdj6mr/o/NiD3z4kkjO5H4eFBU5UmtGAdaCIKvnLr
	otxTZscBjfAwU6IjhpjXOTQCU+QijOCJ0iv8VP0DtnreTP6EkgQD2w9kihkjS5fBxTpce83Q0hJ
	4YWZo/Uoc75cgLVBy+uagaNskJrJNMaRsvuKsL/TzMJqJkukBBRUq8rDJm6pYGt7npbtiuW80UL
	S3WgftH9H2lbpI+W8VSQ7Z5NsRacWyJwRX7fxqXPL5znAak5u1KYb4ovWf1Ldf0b2ryW4E=
X-Google-Smtp-Source: AGHT+IGTrXflbA7TuH+HMFPKadliLmhPvmaddni0A+suBBUE0r17KKOfpya47jmQzV7xIWL/JMQTbmyuegC/gaPJ6Kk=
X-Received: by 2002:a05:7022:7f1a:b0:11f:2c9e:87f8 with SMTP id
 a92af1059eb24-11f34c12699mr14026707c88.34.1766053856001; Thu, 18 Dec 2025
 02:30:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251215215301.10433-2-slava@dubeyko.com> <CA+2bHPbtGQwxT5AcEhF--AthRTzBS2aCb0mKvM_jCu_g+GM17g@mail.gmail.com>
 <efbd55b968bdaaa89d3cf29a9e7f593aee9957e0.camel@ibm.com> <CA+2bHPYRUycP0M5m6_XJiBXPEw0SyPCKJNk8P5-9uRSdtdFw4w@mail.gmail.com>
In-Reply-To: <CA+2bHPYRUycP0M5m6_XJiBXPEw0SyPCKJNk8P5-9uRSdtdFw4w@mail.gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 18 Dec 2025 11:30:42 +0100
X-Gm-Features: AQt7F2rd8ZAR0qUouk3bbCRZlGum8CJLI2DtlF-AsBtcTzZCpUDhii1Zu1eXreo
Message-ID: <CAOi1vP_y+UT8yk00gxQZ7YOfAN3kTu6e6LE1Ya87goMFLEROsw@mail.gmail.com>
Subject: Re: [PATCH v2] ceph: fix kernel crash in ceph_open()
To: Patrick Donnelly <pdonnell@redhat.com>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, "slava@dubeyko.com" <slava@dubeyko.com>, 
	Pavan Rallabhandi <Pavan.Rallabhandi@ibm.com>, Viacheslav Dubeyko <vdubeyko@redhat.com>, 
	"ceph-devel@vger.kernel.org" <ceph-devel@vger.kernel.org>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, Alex Markuze <amarkuze@redhat.com>, 
	Kotresh Hiremath Ravishankar <khiremat@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 18, 2025 at 4:50=E2=80=AFAM Patrick Donnelly <pdonnell@redhat.c=
om> wrote:
> > >  Suggest documenting (in the man page) that
> > > mds_namespace mntopt can be "*" now.
> > >
> >
> > Agreed. Which man page do you mean? Because 'man mount' contains no inf=
o about
> > Ceph. And it is my worry that we have nothing there. We should do somet=
hing
> > about it. Do I miss something here?
>
> https://github.com/ceph/ceph/blob/2e87714b94a9e16c764ef6f97de50aecf1b0c41=
e/doc/man/8/mount.ceph.rst
>
> ^ that file. (There may be others but I think that's the main one
> users look at.)

Hi Patrick,

Is that actually desired?  After having to take a look at the userspace
code to suggest the path forward in the thread for the previous version
of Slava's patch, I got the impression that "*" was just an MDSAuthCaps
thing.  It's one of the two ways to express a match for any fs_name
(the other is not specifying fs_name in the cap at all).

I don't think this kind of matching is supposed to occur when mounting.
When fs_name is passed via ceph_select_filesystem() API or --client_fs
option on mount it appears to be a literal comparison that happens in
FSMapUser::get_fs_cid().  Assuming "*" isn't a valid fs_name (it it was
the cap syntax wouldn't make sense), the user passing "*" for fs_name
when mounting would always lead to an error.

Thanks,

                Ilya

