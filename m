Return-Path: <ceph-devel+bounces-2250-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 10E8A9E54DF
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 13:02:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 25B591883C3E
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 12:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6219A21772F;
	Thu,  5 Dec 2024 12:02:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="COnSVc/I"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90E2D217705
	for <ceph-devel@vger.kernel.org>; Thu,  5 Dec 2024 12:02:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733400144; cv=none; b=UYVFBNls+8E64Ml9B8IsJmn9EgHzO5+EL6LcaPSBlfNGmzFcbzeJOJTuwT5zW2W8zhkGV5Ly5HpBX3GDCC3E0AN4mXSC/WBg9U9++yu6fAiei17oWT+jRyeGKp+2p21gKyOGS+UjQ8BTf2KVE0CiYfqBr1o4YrovTAjE3ePKqRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733400144; c=relaxed/simple;
	bh=XyfEByJLaXEI2J7PmhW3DYY/suyZlc64UiioSv8hnSE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZIWhG2DNPtV1odqC9+E3ZTXbqgkH+MlT5BAV0QUxTturNk1tdF2PopxTHSjDx0p+FA1ZNhZwLTXUpdeMrKClEsZiPTbMHg0jWuGpuw4ixdZWR1sXaBve55QDACgW8EM1btx3ukj5gt8da5VSfHl8BADBqShnYQPG0Gt6tw2bOnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=COnSVc/I; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5cf9ef18ae9so3459430a12.1
        for <ceph-devel@vger.kernel.org>; Thu, 05 Dec 2024 04:02:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1733400140; x=1734004940; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XyfEByJLaXEI2J7PmhW3DYY/suyZlc64UiioSv8hnSE=;
        b=COnSVc/Imj0aebKx+Q/QZcP/abJAbERCNVw0vdInpdnuFupObDgXwxboolpmU/MVMe
         6Cp8cqQTsnGBa52W9NXCI8FmAOdwkrQ2pu28/1LOUgleQvWeMUu+3gJ4BpwDO4fW/V19
         lWmOPzlyZ4s1X2jj1md2eSmoc8jMfs9f3Zdp0OxqWyXc9sNQJPQbZDtfqAXTtEA7aT3+
         Q64kY495kiT8cXwNbZzBPrHqJPLKC7cBI8tdn0HgJzNAPizLmtlgvwGxoJ7RnFZQHEqc
         5ZhHdkRO6guQn4fSfyAKtJjogX2HcVUZgfBua2YSDmVelkXjdK3Qvz+s/953R0cenqfR
         1GWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733400140; x=1734004940;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XyfEByJLaXEI2J7PmhW3DYY/suyZlc64UiioSv8hnSE=;
        b=wJOVVjR1JYr99iupb2IAZ0KgDCTSAnC9xkLjuCpdEY+5HHCR4k9iLXwLGTdJ0Z8z7K
         gvakLXDJWr5n+OJx4U7qOFUWFqS9UIMiv0b9ftXmlEVU8YJb8ZxuxSybopfxQp0p0gKc
         x9CIDrZmxKLN0hJ15Y5HoD4x8YdZIB8LVcnQvOBqzJXI3ZVUx1yb8VKKM+Fcp1T04kya
         7B30JXcnOMOA96ZWwGyZmLNvevXs123m2/nYzrlebNDmrK7G1hdgk8o0Rky8m+h+BHAM
         fDQpvMdBYHFzXScnWYhSYnchVP7E68p9Ed6X40MLqa87E/uPO3ZT+bCkKa/NPXUPS4/K
         tKAA==
X-Forwarded-Encrypted: i=1; AJvYcCXr+PlPrJd1tCtSvt0/xxOQqKN+Btqmi+9PO2VoKY9IVziwZAqF1CVi83zSuq7BCbNmCDHSh4h5rJit@vger.kernel.org
X-Gm-Message-State: AOJu0YwUL57Wnfx+VWuxCURr90VYK3ZaZ/oObeJzyit5cvBRzAwuLaTm
	nUUzRr1Rkw4wcnJ259bajkxn1gUn8UiKrwhCtsqAylLMBEult2jex0ncOvlldvwRjB5Y3S1XMBC
	Tx9dPZCehWbSR/c3SKDImVk+mjUl7OXyi+e+GCA==
X-Gm-Gg: ASbGnctCZ0QtnGpcHACzP4vpOHwQ5+Q1pVcqbodN3JVx3nC0u2NjQAgEUz51C+6EVDO
	P6x8ukbUMnmelenzlUlmzCKIDX5lgLVPlnNma/mSvTp8CWvR6W5vst1uFQIrA
X-Google-Smtp-Source: AGHT+IFP/wTYLryFFk8fTdYJy5qaJwWOgpmG9awKpo+rmgz0NzwBMJtXwwZap8har7hG0jmGiguupw0DwGkLQ1i6mfw=
X-Received: by 2002:a17:907:7e86:b0:aa5:4e27:4bbe with SMTP id
 a640c23a62f3a-aa621a3da23mr246213366b.27.1733400139827; Thu, 05 Dec 2024
 04:02:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241127212027.2704515-1-max.kellermann@ionos.com>
 <CAO8a2SiS16QFJ0mDtAW0ieuy9Nh6RjnP7-39q0oZKsVwNL=kRQ@mail.gmail.com>
 <CAKPOu+8qjHsPFFkVGu+V-ew7jQFNVz8G83Vj-11iB_Q9Z+YB5Q@mail.gmail.com>
 <CAKPOu+-rrmGWGzTKZ9i671tHuu0GgaCQTJjP5WPc7LOFhDSNZg@mail.gmail.com>
 <CAOi1vP-SSyTtLJ1_YVCxQeesY35TPxud8T=Wiw8Fk7QWEpu7jw@mail.gmail.com> <CAO8a2SiTOJkNs2y5C7fEkkGyYRmqjzUKMcnTEYXGU350U2fPzQ@mail.gmail.com>
In-Reply-To: <CAO8a2SiTOJkNs2y5C7fEkkGyYRmqjzUKMcnTEYXGU350U2fPzQ@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 5 Dec 2024 13:02:08 +0100
Message-ID: <CAKPOu+98G8YSBP8Nsj9WG3f5+HhVFE4Z5bTcgKrtTjrEwYtWRw@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/file: fix memory leaks in __ceph_sync_read()
To: Alex Markuze <amarkuze@redhat.com>
Cc: Ilya Dryomov <idryomov@gmail.com>, xiubli@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 12:31=E2=80=AFPM Alex Markuze <amarkuze@redhat.com> =
wrote:
> This is a bad patch, I don't appreciate partial fixes that introduce
> unnecessary complications to the code, and it conflicts with the
> complete fix in the other thread.

Alex, and I don't appreciate the unnecessary complications you
introduce to the Ceph contribution process!

The mistake you made in your first review ("will end badly") is not a
big deal; happens to everybody - but you still don't admit the mistake
and you ghosted me for a week. But then saying you don't appreciate
the work of somebody who found a bug and posted a simple fix is not
good communication. You can say you prefer a different patch and
explain the technical reasons; but saying you don't appreciate it is
quite condescending.

Now back to the technical facts:

- What exactly about my patch is "bad"?
- Do you believe my patch is not strictly an improvement?
- Why do you believe my fix is only "partial"?
- What unnecessary complications are introduced by my two-line patch
in your opinion?
- What "other thread"? I can't find anything on LKML and ceph-devel.

Max

