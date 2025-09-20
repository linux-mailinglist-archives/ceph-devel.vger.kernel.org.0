Return-Path: <ceph-devel+bounces-3698-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 95CA9B8C000
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Sep 2025 07:48:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6928D1C01C26
	for <lists+ceph-devel@lfdr.de>; Sat, 20 Sep 2025 05:48:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A311422DFA5;
	Sat, 20 Sep 2025 05:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jvFQtz/e"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918AF218580
	for <ceph-devel@vger.kernel.org>; Sat, 20 Sep 2025 05:48:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758347282; cv=none; b=QFi3UNSEd+qBFXSNnTg1tEdEeWHthWCVeFWTVOkuk0P8hJDnIVlGgtCy3iLHqNzgDe7xxXjAVpQT80MkoOzXP7pnXNQ707/FtfhcxM7vokyNRB1wy5jeaBAe2XRq7eFI3s6RYn33MIJMbrxVQsv4lh0nUlkYSSLn/fEZKj7d5T8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758347282; c=relaxed/simple;
	bh=o437aCkcf1xCxm+rv0mPwnGQtCoz+9QjMvmAbd5CG3k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IlLkttdGUOPoKudoUk34PDVoky2ezJQeyNVlgArZMwepDCKYsACcic2t0E6M5LCAxdmO3tAtVzYj+1D0zArutAxAB4oRlA2elZrAC8hN4MPGgTzjuhUFuNCQjKcnXanuoyByylvBX8lycJgtw6tyDM5OCeOfnl5IeBkZYEFr5rE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jvFQtz/e; arc=none smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-62ecd3c21d3so4199558a12.0
        for <ceph-devel@vger.kernel.org>; Fri, 19 Sep 2025 22:48:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758347279; x=1758952079; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fyN9RcfnRhBee1hQgE+lsezNr/j9kdfLGgOBZcxycjE=;
        b=jvFQtz/eYM+NLGU5wKQz8AH8+J1N6i7yiK70ybgHeyj1Nqt3MpUnt0ptB0V5rqNNdx
         y9FCHiVC4NzIj4m/dqvUSDf5Ay7MA6YPbem+VbXf2aZ0NWpkzKgfjdRZZx0qc+lJjsEw
         KAvK+Pum6jWrqeQMgjhX+xnQz8SaKlMj3bdzaQ4YFGLqThdG8cQMiriMz9AX/WwdePxH
         VSIt6PWxgmFAwad3XxwSL0FMZB4cr8xZ/cdU8oBWLpOix39fJYgBXTFjH1sNNnLsowm1
         lNDp+A1teDRrWiE+un0tv30D/PKCul57wt6iJ+dl+oycDfEYGKivtfb8s8kpAJb7b/vY
         vowg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758347279; x=1758952079;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fyN9RcfnRhBee1hQgE+lsezNr/j9kdfLGgOBZcxycjE=;
        b=ZLTE29seIoTszPcpWkMyuSP7eFydYqIoLy52GN99fGtU29S0iAowmJDnQup+MFB7u/
         m71+UckeNmh/BTB0bXnKAG7wLeqgJoL1YKbWLtgmHonM7/1ItcQTkfhcQ09WK0En92YG
         +/1/g/AgtzAT3pCHeY409iPu8SGomWsCQ0TdtpkUM8w9moNVsESLgLIevJhJ6R3o1mdF
         /Roa4jnYhcAH/SofBmGEAXbZ0pt4jmzrIRMoQweEZ6AAKqAX9HuTmmITGQYUELN6CSOD
         ZBRfoyK2feKAP+fHZBaOMHD+h60eaujy050ra8TSzGDT4OSLdR+ZwTfL1OjGyiXZHKCG
         DTjg==
X-Forwarded-Encrypted: i=1; AJvYcCWSkcGt1H6mTVlRry9TgPJbyB2S2UUcBaI8fSk0O1z/BhIj+uLN1RYySbwuAAk2x4HQD2WrU2sY0Bfq@vger.kernel.org
X-Gm-Message-State: AOJu0YxamVHH+ZNjQvJypoVIJ51rJ2U1GPjUJLZHYth5OGoT3d0pzm/q
	zZigrwtKVwGYGLqIdo5Iv0SmyvSzlNQGD11V0C0cI6l+Rd1UjcCxn/FmUIVkOCYnvGQE7OTPoAN
	+ayg2SwTU7iq8Qa+/OloJWpQEya0JK08=
X-Gm-Gg: ASbGncticWElCpc1Tz9S4FR/Qw0gJGzUVRIl0VEyNO/VnusL7zx6ZhNMX3mfflkCqlZ
	ii8iW9oBJr6TvD7uKMOjZ0vuRNk4V3mK20ljubWKxVW1VYtAPOWPeE3qrjfdJzAJK6ZMNLERs2R
	IpojHT5TXXPbDDHLsr8h7/HjBwPHes+oi781EjIjCK5lrZA5sfXkc/j7xYoaLJb3wBj2IujGiSd
	1UzQ4MJvnh77OE/nanjXfYWhs2w8y2V+tatyk0=
X-Google-Smtp-Source: AGHT+IGXjKiqqwRe65Vudg38Ap/YqUkQCp5A7+RF7b7HLmhZNE/B/g21D2F70GxNir3tx2mYIaHz6z79YrnZKfqUJP8=
X-Received: by 2002:a05:6402:23d2:b0:62f:9cfb:7d76 with SMTP id
 4fb4d7f45d1cf-62fc0a8376bmr4633977a12.37.1758347278669; Fri, 19 Sep 2025
 22:47:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250919154905.2592318-1-mjguzik@gmail.com> <73885a08-f255-4638-8a53-f136537f4b4c@gmail.com>
In-Reply-To: <73885a08-f255-4638-8a53-f136537f4b4c@gmail.com>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Sat, 20 Sep 2025 07:47:46 +0200
X-Gm-Features: AS18NWCzvbrmV0HH3sAfFvM4WSZtLcuzJvUuWZCgEFT-KVn1SkU22A6rQ1aMITw
Message-ID: <CAGudoHHnhej-jxkSBG5im+QXh5GZfp1KsO40EV=PPDxuGbco8Q@mail.gmail.com>
Subject: Re: [PATCH v5 0/4] hide ->i_state behind accessors
To: Russell Haley <yumpusamongus@gmail.com>
Cc: brauner@kernel.org, viro@zeniv.linux.org.uk, jack@suse.cz, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	josef@toxicpanda.com, kernel-team@fb.com, amir73il@gmail.com, 
	linux-btrfs@vger.kernel.org, linux-ext4@vger.kernel.org, 
	linux-xfs@vger.kernel.org, ceph-devel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 20, 2025 at 6:31=E2=80=AFAM Russell Haley <yumpusamongus@gmail.=
com> wrote:
>
> On 9/19/25 10:49 AM, Mateusz Guzik wrote:
> > This is generated against:
> > https://git.kernel.org/pub/scm/linux/kernel/git/vfs/vfs.git/commit/?h=
=3Dvfs-6.18.inode.refcount.preliminaries
> >
> > First commit message quoted verbatim with rationable + API:
> >
> > [quote]
> > Open-coded accesses prevent asserting they are done correctly. One
> > obvious aspect is locking, but significantly more can checked. For
> > example it can be detected when the code is clearing flags which are
> > already missing, or is setting flags when it is illegal (e.g., I_FREEIN=
G
> > when ->i_count > 0).
> >
> > Given the late stage of the release cycle this patchset only aims to
> > hide access, it does not provide any of the checks.
> >
> > Consumers can be trivially converted. Suppose flags I_A and I_B are to
> > be handled, then:
> >
> > state =3D inode->i_state        =3D> state =3D inode_state_read(inode)
> > inode->i_state |=3D (I_A | I_B)         =3D> inode_state_add(inode, I_A=
 | I_B)
> > inode->i_state &=3D ~(I_A | I_B)        =3D> inode_state_del(inode, I_A=
 | I_B)
> > inode->i_state =3D I_A | I_B    =3D> inode_state_set(inode, I_A | I_B)
> > [/quote]
>
> Drive-by bikeshedding: s/set/replace/g
>
> "replace" removes ambiguity with the concept of setting a bit ( |=3D ). A=
n
> alternative would be "set_only".
>

I agree _set may be ambiguous here. I was considering something like
_assign or _set_value instead.

I'm not that fond of _replace but I'm not going to really going to
argue about any particular variant.

The good news is that whatever the naming, sed indeed can be used to
adjust the patchset. :)

