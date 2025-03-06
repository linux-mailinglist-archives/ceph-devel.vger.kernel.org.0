Return-Path: <ceph-devel+bounces-2867-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F16FA54BEB
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Mar 2025 14:20:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3BA3B3A363B
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Mar 2025 13:19:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9577D20E00B;
	Thu,  6 Mar 2025 13:19:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zk3qtcQB"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC4F204C28
	for <ceph-devel@vger.kernel.org>; Thu,  6 Mar 2025 13:19:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741267179; cv=none; b=pOq4oKfMK4cHdNTVLmejW+Nhwaem7GHyWDuvgILX1nLwPScrc00BiJlnFQbDOtSBV/pghitEQb3nyg9iwmFWPHy4AJQ+kTgIs+Wzpzl2TpXFayJY5jlwIM8tF39fNty4pe1/N5dG/sTIN5F2OxxNBS6Kd0qAQciDMKTJq+shgig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741267179; c=relaxed/simple;
	bh=/UmRarJMMJ5YwDkxVjdSIsPu4GtiRgK/KoqehN6cnEI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UrAIlNlIOQqJnoLmzsMn7k3D8NOJOToFbepQJttfepcUydQMWEnXNh8PGl7JCujLUGkGWjjjrxlXN8FS+j+iJKUaol/4lF/O+70yVw2TFpcGOJS0A+ZTB6WpDMODprnzaH/1z8y0XNhE99fWVvf5vnYfKxXGqsnKuMh60Q4u4vA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zk3qtcQB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741267176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/UmRarJMMJ5YwDkxVjdSIsPu4GtiRgK/KoqehN6cnEI=;
	b=Zk3qtcQBSkCWbf+/QfpeN6LocNul3tXuSS8V8qDgKC+iA9rI9Dl2l1NUhjw3qwK0Ju+gwb
	eN/CXE7ZbSUene0iIntedBgXAEfu7wgLSnkXoeZop2RwnBM5ITGcoLjeZ5bljySvMMVwVV
	3Emh7f1UCdxLT7pgthVCh8OAkyxgnHo=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-269-uKXUfrSXPNOPH3moUp6LXQ-1; Thu, 06 Mar 2025 08:19:35 -0500
X-MC-Unique: uKXUfrSXPNOPH3moUp6LXQ-1
X-Mimecast-MFC-AGG-ID: uKXUfrSXPNOPH3moUp6LXQ_1741267175
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-523a02ace1bso884950e0c.0
        for <ceph-devel@vger.kernel.org>; Thu, 06 Mar 2025 05:19:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741267175; x=1741871975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/UmRarJMMJ5YwDkxVjdSIsPu4GtiRgK/KoqehN6cnEI=;
        b=H09X6bBmcLs1URkpPxsFhav/2YV7rOrG0j7asWtDnNCDvLW5wdzsQeZf/Knr3FWhqb
         DpBDWsVcY8EkRQWX3UeGUBRsXlEDjFS9r9IPH/Q0offpGD/YHgZ2Q67v8+GBIeDzXeju
         3G7rxGSNTVDrgcoR30vVXQz+eBMZWkIaN0ViPmS1dqGAl5Jk7avPldUSxnQKkvWk5bY5
         2tyJbPH/giLMjO7e99APycNvKkQJBkug5qb2KnN7Na7r4ggmdIPAZC1zoUsXICHbtMAC
         aHvuVmWzNfpxaFGeT9pGHTiyM7I0nJCCMAavZPKSOczNWIT7bz5LeBfV9yGxtoM5iOXF
         /kxA==
X-Forwarded-Encrypted: i=1; AJvYcCVCtlwKu0lhdhaKT34Qr/VFdnFmSKAbIc/wMygQ9akwZliPBEy6b4wU0BOMpYfIfHYU4VRgfva0S7Av@vger.kernel.org
X-Gm-Message-State: AOJu0YzLRsBmdcP8/OXQ5TiF4m2T3QfIcoU0eZ3ef/ajQhY+905K0MTh
	3iCFb5lG+eEbcpw97lr/REJCTJczgXuwgcrPJsawl7e/jfDOJpEy+Xb2qJTcy7tCzHrMuTmNVmR
	qBXMLH3gLp4SUCnd7qPX/zLbg2VcF7gx1CMGC43iaHPYl4wIAVXNyksRPLkpQESdgoG5R1DWwpF
	nEGxzQnJIxk/1Kit/rmSDOyw1FqtHThYNqjHPHS4lo5UiQ
X-Gm-Gg: ASbGncuVp6F6H1D5qFOQC/+1vVg7OhYpZhPL1m85VcmyMOzTsLQwh583/cFrm68WqH0
	IN60EODu0LbBo6WzKVKHVg4mykZ5O95wKtqMSE5BfcfgH9mKFJTkJvbFBT/aK1aB0Z3HLzTdg
X-Received: by 2002:a05:6122:2011:b0:520:5e9b:49b3 with SMTP id 71dfb90a1353d-523c614d999mr4605207e0c.3.1741267174868;
        Thu, 06 Mar 2025 05:19:34 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEHLEtL0W98X3g+hM+4bHJAgb1OIWKIGaTCaPzhCsDaa/IpOXbx0OwPWffGYSed4LbV0sDemUiBGgJXdVEG/3w=
X-Received: by 2002:a05:6122:2011:b0:520:5e9b:49b3 with SMTP id
 71dfb90a1353d-523c614d999mr4605187e0c.3.1741267174635; Thu, 06 Mar 2025
 05:19:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3989572.1734546794@warthog.procyon.org.uk> <4170997.1741192445@warthog.procyon.org.uk>
 <CAO8a2Sg2b2nW6S3ctS+H0F1Owt=rAkKCyjnFW3WoRSKYD-sSDQ@mail.gmail.com> <4177847.1741206158@warthog.procyon.org.uk>
In-Reply-To: <4177847.1741206158@warthog.procyon.org.uk>
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 6 Mar 2025 15:19:22 +0200
X-Gm-Features: AQ5f1Jo-1L5xeXHFhQa3Tt-48u5cZdpLKv9zx26z8y6mEFdAUXn0xGXyLS1FSA4
Message-ID: <CAO8a2SjC7EVW5VWCwVHMepXfYFtv9EqQhOuqDSLt9iuYzj7qEg@mail.gmail.com>
Subject: Re: Is EOLDSNAPC actually generated? -- Re: Ceph and Netfslib
To: David Howells <dhowells@redhat.com>
Cc: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>, Ilya Dryomov <idryomov@gmail.com>, 
	Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org, 
	netfs@lists.linux.dev, linux-fsdevel@vger.kernel.org, 
	Gregory Farnum <gfarnum@redhat.com>, Venky Shankar <vshankar@redhat.com>, 
	Patrick Donnelly <pdonnell@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Yes, that won't work on sparc/parsic/alpha and mips.
Both the Block device server and the meta data server may return a
code 85 to a client's request.
Notice in this example that the rc value is taken from the request
struct which in turn was serialised from the network.

static void ceph_aio_complete_req(struct ceph_osd_request *req)
{
int rc =3D req->r_result;

On Wed, Mar 5, 2025 at 10:22=E2=80=AFPM David Howells <dhowells@redhat.com>=
 wrote:
>
> Alex Markuze <amarkuze@redhat.com> wrote:
>
> > That's a good point, though there is no code on the client that can
> > generate this error, I'm not convinced that this error can't be
> > received from the OSD or the MDS. I would rather some MDS experts
> > chime in, before taking any drastic measures.
> >
> > + Greg, Venky, Patrik
>
> Note that the value of EOLDSNAPC is different on different arches, so it
> probably can't be simply cast from a network integer.
>
> David
>


