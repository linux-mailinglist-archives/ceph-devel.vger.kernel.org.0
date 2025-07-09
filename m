Return-Path: <ceph-devel+bounces-3286-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 416D1AFF16B
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Jul 2025 21:05:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 79ED8564158
	for <lists+ceph-devel@lfdr.de>; Wed,  9 Jul 2025 19:04:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 022EA23E34D;
	Wed,  9 Jul 2025 19:04:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="gNSh2cAx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59EFA23C4FA
	for <ceph-devel@vger.kernel.org>; Wed,  9 Jul 2025 19:04:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752087888; cv=none; b=f5+2sMTu4ytxQ6vAFcuup7JePL27r1IQ8EkUryy9uvQYqFETq+JggmYSLL0wI8xZkYNZyFsgi56Ter6ZxwVOw8Y5avHorj7QHqTbXlj0vWtTLv6SnMS/lCy3i0WFNm2vw+zbZcJqBdw96QoklGZAgybkMKzj7Fu5S10XdDW4CyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752087888; c=relaxed/simple;
	bh=oRGJxOoY6Sb9QvNhIjZ1ZJhSnfSKCQdsXzj4pLtR8xc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IFpdQNqOOUX+LhbD/VhU4PwJgRK/t+yczcZNN+cBY2DuhXRO9bheYM7VOuTV6+BjPjEw1QOFgzl82HHvoF5qsjRapU6OsLlOtraMrvUbb75lcIz4wP1052v0IWan7hIfHEGuPHfTb9M8wIZuAUQGhj7GX7vS7LUi5PSorP639CY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=gNSh2cAx; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-60707b740a6so219032a12.0
        for <ceph-devel@vger.kernel.org>; Wed, 09 Jul 2025 12:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1752087885; x=1752692685; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3oMoCHTAV5NeIpZMq+DMEKC+TktfxuQeI3NG81ytBeE=;
        b=gNSh2cAxDTBJoHztwizWyZZ3DiFKTi3wxKyznQsDnWmd1QbZGN06zsxFOINFhEp7IB
         yfLbtqYSVkGMDhyxZGxjcQN0jFYGzFPHVc2AZqXty9tL0Ju71UroMih9Mr3iu6qqV7nj
         lw3c1trpU/sgXaZdW46x5q3VycvC+Kx/pxnQQXN9w6q3xMS7sKadXvuhVHVnzfWr63rJ
         u3NymWMMO1a7A8hAtX4WzUdkDKBocrk80U9+CLlbQYfVpTVOE9lLlTSmGtusmKB//WrA
         AnSkmEGx+FU8/5DPnl1aVOIkMS+Pl+t1jRpA/y/1wOVURm5tvoZL7W7LiTNKp7/jsU5m
         hanw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752087885; x=1752692685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3oMoCHTAV5NeIpZMq+DMEKC+TktfxuQeI3NG81ytBeE=;
        b=s9keNEITbcHi41qWxYuVJMTAFs47GJeOz267oEPT6T4ssqGmmlmoRuZLFnlyMEKDIv
         1lvTOvysMeObKULT6kp99g/+TMgG5xnC8iPFRCOe8SLlX0qbyfiv0Wi5c4Ghnzha6ePH
         xi4x72qlC4f6re89ZKdxLBFJQv/+/oSMbMIq4UwOui4A4LOWOEgVqiZKN/EL/PF4SPeJ
         p/HKRpxFEbBVHHnw3xpLtD7o02A/SPS+IsAMXl5sjsELP0Fmsa6V1O3CNOVHic4sdUBS
         P63IH4HP/xRykQlrbrwxZ5VxDTdOLZbuoBsKByTV/tt81kTSVAr1TXYNUrY9AuN/aMJB
         MKug==
X-Forwarded-Encrypted: i=1; AJvYcCVlnGPqyS/AF0L82dZS9YXZMLxn2fXafZjCQt1lxgKRGrR3UWK83eC+2DenPOkQHdhMrsvKB/yN8uVV@vger.kernel.org
X-Gm-Message-State: AOJu0Yx74ldWvvheGOtoGmKy8Dm6KCNKSCk/ZG7O0ZPKWU0uKepVOhs7
	Z+IQMrnLM/XTecf72+pz14GgwKXMVif9WdRhCNYMhyiKabeu3uG0qmT7vyg1fBVG3wAidGqYSNc
	bJPpb+x06mY6SBqcro8JGVBjvaEFimTLSP70t12yMGg==
X-Gm-Gg: ASbGncu19IDRNcdhSQv0cNd7oQCce0lZW2S2W2GXA7ApUdcb0vDBHR5dq5KXgWF+KhB
	wncw7jrijkROuVTR1IcRiGpmI1DjbIQtA802H72OhNy6Jm9FPlJ2q0AytMUSgtoaPNzKBeKXwC/
	eDe96uqcayPPVd9M+BfZWM1DylltrXylO07qr1KrUYnY0jZClBt8FXcwz8/YHnOycp3wBQnvnZF
	LOuGVyx8g==
X-Google-Smtp-Source: AGHT+IHHFatUYcYPUIaiNLDpnLA9ZJlzI11FgOes6AgoJS9tnoz2rAKkdasV4aiimfA44DVTmm7JJ+DkAfN2TlJGB04=
X-Received: by 2002:a17:906:c116:b0:ade:450a:695a with SMTP id
 a640c23a62f3a-ae6cfbea8f3mr343461166b.61.1752087884599; Wed, 09 Jul 2025
 12:04:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250701163852.2171681-1-dhowells@redhat.com> <CAKPOu+8z_ijTLHdiCYGU_Uk7yYD=shxyGLwfe-L7AV3DhebS3w@mail.gmail.com>
 <2724318.1752066097@warthog.procyon.org.uk>
In-Reply-To: <2724318.1752066097@warthog.procyon.org.uk>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 9 Jul 2025 21:04:31 +0200
X-Gm-Features: Ac12FXxBjj4Q8rQSAFMTvxq4Dux5Rk-Aycgaq2Qj_9vYK8pVlc0gHVgIsMegDWo
Message-ID: <CAKPOu+_ZXJqftqFj6fZ=hErPMOuEEtjhnQ3pxMr9OAtu+sw=KQ@mail.gmail.com>
Subject: Re: [PATCH 00/13] netfs, cifs: Fixes to retry-related code
To: David Howells <dhowells@redhat.com>
Cc: Christian Brauner <christian@brauner.io>, Steve French <sfrench@samba.org>, 
	Paulo Alcantara <pc@manguebit.com>, netfs@lists.linux.dev, linux-afs@lists.infradead.org, 
	linux-cifs@vger.kernel.org, linux-nfs@vger.kernel.org, 
	ceph-devel@vger.kernel.org, v9fs@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 9, 2025 at 3:01=E2=80=AFPM David Howells <dhowells@redhat.com> =
wrote:
> If you keep an eye on /proc/fs/netfs/requests you should be able to see a=
ny
> tasks in there that get stuck.  If one gets stuck, then:

After one got stuck, this is what I see in /proc/fs/netfs/requests:

REQUEST  OR REF FL ERR  OPS COVERAGE
=3D=3D=3D=3D=3D=3D=3D=3D =3D=3D =3D=3D=3D =3D=3D =3D=3D=3D=3D =3D=3D=3D =3D=
=3D=3D=3D=3D=3D=3D=3D=3D
00000065 2C   2 80002020    0   0 @0000 0/0

> Looking in /proc/fs/netfs/requests, you should be able to see the debug I=
D of
> the stuck request.  If you can try grepping the trace log for that:
>
> grep "R=3D<8-digit-hex-id>" /sys/kernel/debug/tracing/trace

   kworker/u96:4-455     [008] ...1.   107.145222: netfs_sreq:
R=3D00000065[1] WRIT PREP  f=3D00 s=3D0 0/0 s=3D0 e=3D0
   kworker/u96:4-455     [008] ...1.   107.145292: netfs_sreq:
R=3D00000065[1] WRIT SUBMT f=3D100 s=3D0 0/29e1 s=3D0 e=3D0
   kworker/u96:4-455     [008] ...1.   107.145311: netfs_sreq:
R=3D00000065[1] WRIT CA-PR f=3D100 s=3D0 0/3000 s=3D0 e=3D0
   kworker/u96:4-455     [008] ...1.   107.145457: netfs_sreq:
R=3D00000065[1] WRIT CA-WR f=3D100 s=3D0 0/3000 s=3D0 e=3D0
     kworker/8:1-437     [008] ...1.   107.149530: netfs_sreq:
R=3D00000065[1] WRIT TERM  f=3D100 s=3D0 3000/3000 s=3D2 e=3D0
     kworker/8:1-437     [008] ...1.   107.149531: netfs_rreq:
R=3D00000065 2C WAKE-Q  f=3D80002020

I can reproduce this easily - it happens every time I log out of that
machine when bash tries to write the bash_history file - the write()
always gets stuck.

(The above was 6.15.5 plus all patches in this PR.)

