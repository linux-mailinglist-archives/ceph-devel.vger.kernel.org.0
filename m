Return-Path: <ceph-devel+bounces-3655-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 246F7B81BD5
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 22:19:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E0EAE4A4D2D
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 20:19:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1C0E27E040;
	Wed, 17 Sep 2025 20:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="CLsAjjPD"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5092AD3E
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 20:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758140382; cv=none; b=jaQeFMu1/PLtUsC4DUhjV/kSTwYHl5JEgb6e49yTQSUZpxJpwDFiDGsiBlqRzZGvlcWNmqa7qMXogWZWziTH107108R5/cqXxQ2ceIquASGUQ7rrQq3m7Ae651/B515XqCEVVCP2svGKksGTR4LfYlAnPlcjqhsJCfP9UP4k/hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758140382; c=relaxed/simple;
	bh=DdJUxUNFZhPzSovCJFZJEIo7a10mS+SVD1T5lJDA/ms=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=N6oWMi4A6b93ReIMpppepP+6jKiVx2R34LdJcMvpcooQsb07P9gCZ17LPvS34zb5VBNJo5UR1JnfywEKRNVPTMp0eVTo1QRhi+jPe2iVsI2T+pQIjXtxMRuatFF+qrBoYeMlzsWvCiuE1yDRIj2c2BcK0aSuM8Jsle8UahzWr7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=CLsAjjPD; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b07c28f390eso35847766b.2
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 13:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758140379; x=1758745179; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DdJUxUNFZhPzSovCJFZJEIo7a10mS+SVD1T5lJDA/ms=;
        b=CLsAjjPDj/JXR+ZfsKLXRmuRlbqMpeXnZSqaDzvzNUfk4FZHY+7/ae/nrGyDyRwCj5
         m9m/I4gYI4lfcEANyfoTnf1IDh6rcbKPaXMywbBC8p8Uzpq85c8LYNjqH45jJsdS+esS
         hqq67SWaZD1/t0ua9uAG+Vttm0ecFMZHHFC2Ze0sqCtoM1iLwiBN0yxzkUUmH9HRlcoZ
         O6uGg+gQyOwwNWFkXmcmDcU018NYqKv0cQOT+YAT3ay+C5ZPh/Fi2V0ibBLtIhkt0/od
         /hOjQU9yyR/ppVBWYk8ZxKPI1l8c8RGloUKfA7O4ZgnrBwggBOQdLg1BSZAPiYzaFtP/
         4PmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758140379; x=1758745179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DdJUxUNFZhPzSovCJFZJEIo7a10mS+SVD1T5lJDA/ms=;
        b=knaoRJzO0Fwox3l0xjFzME/YpVwYRM+m5Gl4fynSkyfJzovLHL1XpK/8KRHqV2drFh
         0xLXH+ivC1IYmnsLprTvVBUZaS+WwiYSG0UFRWcixw9RvC44C/XDYR1g5Q1Yb66pmRpf
         F4tiMN5zaYxGDn6WAlbyGl2nhrPU2rOZGUlNKQOKSN4el+uN1/JLD5s0clnJOyxwN91j
         EUX4jtBXznzlT5nKAsCmnaTEUaKqRwUYGSXFzY+AvVTFp4/sLSETSyVl9kpYy2gXka60
         q1tcwUe5LBgSacPuTTZ4CHssVsPkq/P31A9sU41KEviuuJk3IQ+tk58OkYBtAiojIM/G
         ahlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXfib0+Xzxf3aWwWebLsdSJUVpALOhP6cFgh4JZSPrryouNPyvyOoSXfSXpkuRLgyTQ02sPxYgXLncg@vger.kernel.org
X-Gm-Message-State: AOJu0YxoOsilbDy65b5xK5NuQbx0JHo9xeAT+0KBd7xliKZceusOsI6B
	WWZUN6gsvyZ49ydbnAFrwf7iSJXn1MeV8Ma9PQEqPua+ARNXDDInrEstxoNk2C5gmK2isUJcQ0o
	t/fdiJ6XguGJC9XIkRnFhwGYmQqgr5CJmzKHSBCjwDQ==
X-Gm-Gg: ASbGncvQh7xR8d5We8RUsuJ8DjmnVw4zfYtae+Wg52MX2y3laNm/P+HkcUD/4Pnrm9Q
	FyArj+6IuHmyauXZaY1S5TvoYsZ668fnyXbT7GNlETexSdcDCH7HHPp/itGC92GwOr2kK4/w4Gz
	fmr8uZh85eIKtYwHE9QuPgZIoWnGf7rybfLpChPUNRklcNuTkDyoldswVxKTIE0qZeqMfXvsn2D
	Pr7ZQcXQN8hIY2eLb010+xoJqGOVQWAkgF+6t7WKAuskZ5RjVVoWpU=
X-Google-Smtp-Source: AGHT+IFQaLDy/LlqDOKaXH33/5p9CVpaIIbnENcFkO7c6Maci4zFzsFceKZ4fsH5U+Ovj7N6lS3oxCJsn8eTAC3ubkw=
X-Received: by 2002:a17:906:c156:b0:b07:b7c2:d7fc with SMTP id
 a640c23a62f3a-b1bb5e571cemr321943466b.6.1758140378862; Wed, 17 Sep 2025
 13:19:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com> <20250917201408.GX39973@ZenIV>
In-Reply-To: <20250917201408.GX39973@ZenIV>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 22:19:27 +0200
X-Gm-Features: AS18NWBTAX9o17WGEZG3_vr6672P-Z73BzGF9K0FZmb6uSVnrvZWBv6zug26UJ4
Message-ID: <CAKPOu+_WNgA=8jUa5BiB0_3c+4EoKJdoh9S-tCEuz=3o0WpsiA@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mateusz Guzik <mjguzik@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 10:14=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
> Looks rather dangerous - what do you do on fs shutdown?

Sorry, I'm new to this, I don't know how fs shutdown works - stupid
question: is my code any more dangerous than what's already happening
with ceph_queue_inode_work()?

