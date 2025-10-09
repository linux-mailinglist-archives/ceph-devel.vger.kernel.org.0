Return-Path: <ceph-devel+bounces-3809-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 61CD9BC8E3A
	for <lists+ceph-devel@lfdr.de>; Thu, 09 Oct 2025 13:47:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 8681B1A61CB9
	for <lists+ceph-devel@lfdr.de>; Thu,  9 Oct 2025 11:48:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B42902DFA2B;
	Thu,  9 Oct 2025 11:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="RwWMI0NL"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 455E62C21F3
	for <ceph-devel@vger.kernel.org>; Thu,  9 Oct 2025 11:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760010452; cv=none; b=HVgK3EmpQLjzRmVgDz7dmyJrCM6S27w/luTH6Wo4A/70Q+Ak9W/d7QVYbljISdbYwp03OYm62Xk1R+/eNHysXVVvPBuVWizYHnNAlstE13q2wFNvjAlJZiSocxqHHfW0//bo13dyfjCtEANeuQ5Pv7CVr+2FwCSLHOwqaiBjTlk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760010452; c=relaxed/simple;
	bh=botvLY+e+FH2/AeSnmon31xjDAZfoMaKqDI6wcu/lts=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SKqnicoLGdNoLwnx/d8FNZkLdTfIG2xRRLA/S0xCeBZdHxxkjDu7T9XQAOYCG6ur1+1DngbltCLrKpCY8tlqdEgFDz4hXgc7lKajQUmw0FB14IQrgxnMjQLXLI6K64b8DWFKE43NCA0hcfz17PhPMUC9nGrAHnaQ/W2RcUOoDKk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=RwWMI0NL; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-b2e0513433bso140046366b.1
        for <ceph-devel@vger.kernel.org>; Thu, 09 Oct 2025 04:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1760010448; x=1760615248; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=botvLY+e+FH2/AeSnmon31xjDAZfoMaKqDI6wcu/lts=;
        b=RwWMI0NLNTHV/xCq7Euvd8syWK4VVKur+3UW2pcUWo1dMo1trYpVUArXhgNoflCUYK
         0xt90q6nDrk6r7SO6BUqA5HaUQh3crlKZrWTC/sM7PQLHy8TJyKPtmSl/UAohRLns1IV
         XoOlvc9GYykZoA3aJpF0b1W8KK+hCEiD1Fqq/aqB91g/zHpUW2GgOTkf2fQNgJ+shzXy
         /nBxSRcLIfugB8kYTGV6WUf2hGhJnYP+TtQPvYeeg56nTorXhA4vx7itl5iITYf0j4cO
         9R0Ha/r3cxioNVEVHKXRvJGyYUy40cox697MLy/iXjfH135qMzhr9y190/1xx+Ad0lYw
         urRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760010448; x=1760615248;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=botvLY+e+FH2/AeSnmon31xjDAZfoMaKqDI6wcu/lts=;
        b=RrqX8d+JWY1T0aJaJgOlpltO/PMY4OYHHXkPwaZKvXhWx6zGDmz6fvOJa3Foskr9lJ
         kmlC2bGo+bkIr+FTYaSpqhUCMoRWnsydr9r+O+4ZZUYyCN7e1kTSVaxnlBhkMwOHadNA
         80znrJYHsXVCgY8OMJr1txtsKrlLMZ4X+8IU0wRlqnp5+XeEOQO4MrvR/gg778YdH35+
         TszMGrRliBB5MJF4HbpAaYFlq1ZWGktQI61I5K31EEsGMLFJ7KlNB9rIuvc7sInhs4dl
         oXmWu8aUCe3MYUVbnuBPKSOBPPO97xvVCzcYKVMWBQX4JPy0lFF9PJplTc+Q7eVP3IMt
         RZtA==
X-Forwarded-Encrypted: i=1; AJvYcCW2bFx/hT1A4+V2OL7kGRu9MiT/Bsea7G4tso3+B+dZb2Q8PUSrj6tmZPJYDIV4JQFtWnwU0742r97t@vger.kernel.org
X-Gm-Message-State: AOJu0YyZIfGy8ASxpvujhLWtOyhSTmPKcG/6cpjMlxkbDxA1MzhqD1de
	2EQrlk4xtpa60tXZdrr4n6TpKlc7DAv6ayHxHr6IN3KoKycFtP1r/oCLg1RBAX1CHDoBEPrbLxu
	vkV8kpAt4GKBOMlVSkpRaKIxurmI/cJTVg8e53QkuV0WaGTIgYTba
X-Gm-Gg: ASbGncuZ2AC3q05AaJTFDOuoQhSsdiwKUuXGjFcYFbWqg3Uovc4kyv1IATKD4siL5nZ
	VpxznBmywa3tWyi3OO/jt6vbG1EBoIsNYl2eII0jxmkVfJUDoUrdZUmKJF/YR7JG/uea4GCVkcF
	ch5DYEcVHAh2yo1I/74Hoga6ie/SD1qgBixqGxawkHs3dbz+fM76I5IfV8XMKIE1kKYzujn2B3X
	Rm4sKPEeqDsdJ8U85Fb5MaOjcFyG5kon5zGC1Pr+z8bVk6yU1RRtWStUskw
X-Google-Smtp-Source: AGHT+IFO+urlLmzm35on4CiyvY88G8vAyiB+vH7kV4tutVxZBb/l4yIKAnTc99ekEVr5OcqAJELs3grkW6s9boBSV70=
X-Received: by 2002:a17:906:ef04:b0:b3c:8b25:ab74 with SMTP id
 a640c23a62f3a-b50aa393c32mr837268866b.10.1760010448499; Thu, 09 Oct 2025
 04:47:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250806094855.268799-1-max.kellermann@ionos.com>
 <20250806094855.268799-4-max.kellermann@ionos.com> <CAOi1vP_m5ovLLxpzyexq0vhVV8JPXAYcbzUqrQmn7jZkdhfmNA@mail.gmail.com>
In-Reply-To: <CAOi1vP_m5ovLLxpzyexq0vhVV8JPXAYcbzUqrQmn7jZkdhfmNA@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 9 Oct 2025 13:47:16 +0200
X-Gm-Features: AS18NWCi3x367EpbmrZD1bATsg0qYy5Ho_fotqaUYHcMI-fpgH0tghRfYUXXHdg
Message-ID: <CAKPOu+8a7yswmSQppossXDnLVzgg0Xd-cESMbJniCWnnMJYttQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] net/ceph/messenger: add empty check to ceph_con_get_out_msg()
To: Ilya Dryomov <idryomov@gmail.com>
Cc: xiubli@redhat.com, amarkuze@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 9, 2025 at 1:18=E2=80=AFPM Ilya Dryomov <idryomov@gmail.com> wr=
ote:
> I made a change to net/ceph/messenger_v1.c hunks of this patch to
> follow what is done for msgr2 where ceph_con_get_out_msg() is called
> outside of the prepare helper and the new message is passed in.
> prepare_write_message() doesn't need to return a bool anymore.

But ... why?
Your change is not bad, but I don't believe it belongs in this patch,
because it is out of this patch's scope. It would have been a good
follow-up patch.

There are lots of unnecessary (and sometimes confusing) differences
between the v1 and v2 messengers, but unifying these is out of the
scope of my patch. All my patch does is remove visibility of a
messenger.c implementation detail from the v1/v2 specializations.

(My end goal was to have unified multi-message send in one function
call to reduce overhead for sending bulk messages, but I did not yet
follow up on this idea yet. The Ceph kernel messenger, just like the
user-space messenger, leave a lot of room for optimizations -
unfortunately, my user-space optimizations that I submitted last year
were not merged by the Ceph project.)

Max

