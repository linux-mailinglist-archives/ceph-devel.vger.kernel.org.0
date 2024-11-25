Return-Path: <ceph-devel+bounces-2196-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 661169D881B
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2024 15:33:18 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2B29E28D09B
	for <lists+ceph-devel@lfdr.de>; Mon, 25 Nov 2024 14:33:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F8D41922E9;
	Mon, 25 Nov 2024 14:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QrfPLDME"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4D31B0F11
	for <ceph-devel@vger.kernel.org>; Mon, 25 Nov 2024 14:33:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732545190; cv=none; b=JmE9MzHiqoKrnxPiM9RwP5ku+HmjBby6IUxrRTawtvn6GwREVaxCTZnWMCOjk+q0cu/e92SHGeHGC9FH5+QQRvq8gGyv97p5NB0nISGOJJ8wDPI+eDCN1UgJs9r6KfThlh/fKAavQYdok4vJJElU3eJ7UjBS4HHwFxHUKFJMBto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732545190; c=relaxed/simple;
	bh=Qn+b6ULbHlpt1jjPuozeG76v5+tmKAZ3os+xCJI2X84=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QLJD1Ukjml6AqZ92/uWqzrZIM7Cso3hxVkoP1CbbCBdW/jrHxDWc518C+dGvDd5fdZiXahvXYPWeq3tG06WoI2+FQPqNRU1pnrWZi09CQ55DY8HTmudBJty792IA3EeVSYHqA8hrn0xvobl86QlDBvikewJ53lQc7y+LQLNWMzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QrfPLDME; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732545188;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Qn+b6ULbHlpt1jjPuozeG76v5+tmKAZ3os+xCJI2X84=;
	b=QrfPLDMEGeEVSqFkQadgCGzcpbHGqjY4wMllQDUZ/oA3PScG0rnEO9+IEKDC5HQbde+azS
	78GrHp8kPqUUdQzOq6Pylk2hKkGOU1SF62odjTGoqxzbWjCBu0aevRuDjSXkZdOTZMO6aw
	JD6v4tg9zXInDL04HnTJ/fxzyUBuvfs=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-223-cccvbBqhP_-__8v3I2wy3A-1; Mon, 25 Nov 2024 09:33:07 -0500
X-MC-Unique: cccvbBqhP_-__8v3I2wy3A-1
X-Mimecast-MFC-AGG-ID: cccvbBqhP_-__8v3I2wy3A
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5cfc0004fabso4427061a12.1
        for <ceph-devel@vger.kernel.org>; Mon, 25 Nov 2024 06:33:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732545185; x=1733149985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Qn+b6ULbHlpt1jjPuozeG76v5+tmKAZ3os+xCJI2X84=;
        b=qokVzhsm8tA31wZGpqv9YWdxv7yuA5mRlx/Y1AGQyQdo5cMubX6UKlIKjj/eNv+SdY
         QTEi7MCzQnG4cLwjELRHaGhI/PdCD7iIGFDOcR8XQ8LPoO/Gl8Jsq/38NHmiYDD924+Y
         +UTgXyUir+d+vZ/yTqjrWoz2jV7UHNtzhYk3qYN5J86UqWVmz49ELGil2j8KMBBbmCbX
         y8kEkjkbpkJjaSQ2qC9IjdQZ8qnxLUZBaa53K3jzjodxr1KA0ocNepD39zrn/3Lu3nGa
         O4BOPnDU+XGs94haaubiLuLId11OoABqHv6oyRElMzzTHIQ/qiMpfXAz3mwxz4m6D1xG
         v2lA==
X-Forwarded-Encrypted: i=1; AJvYcCXtOmqNhAOP6sF2UFVgcZea3f0AUFGNxel2+3ot7zpkh7S627Zm2jy4HmAxlCqgH09CmCQ0U51EgHOk@vger.kernel.org
X-Gm-Message-State: AOJu0Yxy2QXZ4RDUjrvjuU5DmCJxHpHd5gfszjSgWQq0jUCbILhSMIpW
	90SxuRHommDMZylAZaQWfzNUR6ib540zaUa/boj8ylRvRYRPNzE3gtImxdAf9bpkh8c2itCkV0i
	AusbowEwYzROMnBgARP57oYjtS8e9KIw1z0tG0Ep93vK2iX1+8PNYFw+xsHkszG3NsqkUTtoCJA
	vO/dEeQK78rvdX7pRsrbTugj9Ze/ChKKwy5fpcTmTsEp3tfrU=
X-Gm-Gg: ASbGnct79mvIgoMyNvoEUDXDPr7HZ8M4W1N2RL+OVx6JwNY1DnVZ73jEwi5pbe95Avn
	HelDF9cLJMb1nvQLmdEpbAlAX0L62
X-Received: by 2002:a05:6402:2686:b0:5cf:d341:dfec with SMTP id 4fb4d7f45d1cf-5d0073daa0cmr17638327a12.0.1732545185581;
        Mon, 25 Nov 2024 06:33:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFdCqEdULNd6cF7hPz8sD3hmROqZwCvCy3SMA6nukUKDBvFTRfZbusOR8nHOeyYxuqRGri9L1xRDyGB9J+PRK8=
X-Received: by 2002:a05:6402:2686:b0:5cf:d341:dfec with SMTP id
 4fb4d7f45d1cf-5d0073daa0cmr17638292a12.0.1732545185266; Mon, 25 Nov 2024
 06:33:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118222828.240530-1-max.kellermann@ionos.com>
 <CAOi1vP8Ni3s+NGoBt=uB0MF+kb5B-Ck3cBbOH=hSEho-Gruffw@mail.gmail.com>
 <c32e7d6237e36527535af19df539acbd5bf39928.camel@kernel.org>
 <CAKPOu+-orms2QBeDy34jArutySe_S3ym-t379xkPmsyCWXH=xw@mail.gmail.com>
 <CA+2bHPZUUO8A-PieY0iWcBH-AGd=ET8uz=9zEEo4nnWH5VkyFA@mail.gmail.com>
 <CAKPOu+8k9ze37v8YKqdHJZdPs8gJfYQ9=nNAuPeWr+eWg=yQ5Q@mail.gmail.com>
 <CA+2bHPZW5ngyrAs8LaYzm__HGewf0De51MvffNZW4h+WX7kfwA@mail.gmail.com>
 <CAO8a2SiRwVUDT8e3fN1jfFOw3Z92dtWafZd8M6MHB57D3d_wvg@mail.gmail.com>
 <CAO8a2SiN+cnsK5LGMV+6jZM=VcO5kmxkTH1mR1bLF6Z5cPxH9A@mail.gmail.com> <CAKPOu+8u1Piy9KVvo+ioL93i2MskOvSTn5qqMV14V6SGRuMpOw@mail.gmail.com>
In-Reply-To: <CAKPOu+8u1Piy9KVvo+ioL93i2MskOvSTn5qqMV14V6SGRuMpOw@mail.gmail.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Mon, 25 Nov 2024 16:32:54 +0200
Message-ID: <CAO8a2SizOPGE6z0g3qFV4E_+km_fxNx8k--9wiZ4hUG8_XE_6A@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/mds_client: give up on paths longer than PATH_MAX
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Patrick Donnelly <pdonnell@redhat.com>, Jeff Layton <jlayton@kernel.org>, 
	Ilya Dryomov <idryomov@gmail.com>, Venky Shankar <vshankar@redhat.com>, xiubli@redhat.com, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, dario@cure53.de, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

You and Illia agree on this point. I'll wait for replies and take your
original patch into the testing branch unless any concerns are raised.

On Mon, Nov 25, 2024 at 3:59=E2=80=AFPM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> On Mon, Nov 25, 2024 at 2:24=E2=80=AFPM Alex Markuze <amarkuze@redhat.com=
> wrote:
> > Max, could you add a cap on the retry count to your original patch?
>
> Before I wrote code that's not useful at all: I don't quite get why
> retry on buffer overflow is necessary at all. It looks like it once
> seemed to be a useful kludge, but then 1b71fe2efa31 ("ceph analog of
> cifs build_path_from_dentry() race fix") added the read_seqretry()
> check which, to my limited understanding, is a more robust
> implementation of rename detection.
>
> Max
>


