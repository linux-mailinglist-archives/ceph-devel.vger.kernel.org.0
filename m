Return-Path: <ceph-devel+bounces-3643-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 989E5B7F5AA
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 15:34:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 090ED4A0AB1
	for <lists+ceph-devel@lfdr.de>; Wed, 17 Sep 2025 13:23:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8EFB41E25EF;
	Wed, 17 Sep 2025 13:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="afT0B43C"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 490F61D516C
	for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 13:23:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758115409; cv=none; b=E7FJuC3oPfXQUBTHvcKqbaf8NEnJA1I9K1KzXnP7eBXE059vsjd8b5DyocSSUeOIxH/hKyUT61sExZ61DxnkJH8zcjpITS/bDCPvACRd58HihlOQg38HDFFsPMpw4MC4mdGWz+VkKvnv6zr19YFBpQ3npeahA7BLL3jSRT+qaOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758115409; c=relaxed/simple;
	bh=Y8hEEtaxcoIdOX6D0RxrN9/EkrrMmofUHUb4qqWKI7E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UUPq9I9BtOQY0/JvJB/XVyun3WLIsbryQY3y15fxK0RRxVQOUKakFo3qUt77P3+6OZhSG4ZBr66A2UsRRIsV/jV5H3k9a1RAqRGH0okT11CVvprNqxlxCIlO6sdKKRUKuglW6Eoyman3A0CiUoDzXkXYkbYU3oTl8KnDyVcKpA8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=afT0B43C; arc=none smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b04271cfc3eso849822066b.3
        for <ceph-devel@vger.kernel.org>; Wed, 17 Sep 2025 06:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758115406; x=1758720206; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y8hEEtaxcoIdOX6D0RxrN9/EkrrMmofUHUb4qqWKI7E=;
        b=afT0B43CvjU8mP41nVb7aQ4/cWPF8eoH5vQ2co/TkR8VIt5m2LJr1KcxXLc7y9A9lz
         xULcQEjfwW/IE0p0nE+FooBcuWtKoWqw11cUtfZHGQf8MZbui4Vm0lRNoKzMRHEdC8Md
         IgBTPi0tXqSkSEcoHy4nBWDHhesEk3SdvZg015+EFZyn/ErE4lkQYlet0E/ACXdyiZse
         82uKO3P88/Yvk6DX4UCScmcZIZpQEZdMhTlXtxUNHE+Hw7+s4upz6v/KPzgfq0AgG85C
         Dnq1aywf5AJy9ZxA7CcPFJT+egOYj5ZAzKB8AC71bO6CjeDQdVgMOKvXbs6mSpHY/3tg
         JQLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758115406; x=1758720206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Y8hEEtaxcoIdOX6D0RxrN9/EkrrMmofUHUb4qqWKI7E=;
        b=EardILR++MCX7xkSmqHizc0iu8eIIgHSqAc8MtSAYXXwmU/LexMi7p2P0clVY5+Ysw
         Y7XR41PpqBhTx2Tzr1J3GXFqSYeSy+eWKiClEm/pKCLfE3cgbb6tjvNK9xkCvWj2KkKK
         Y+flK9A/LL5D9ba3YrR+ER59EzYt5qEBAR1b/tUHf65rCWxZR2JCiOYNSrkQYfJnSOV3
         yjqT0mq8L9no+yMNWaK4Z82GxZdMecYlMPSVOfgwB0yWzT2HVm1WzvEiLfvYtzttcong
         +Sp95zZwFhJAyuKIw6sNHZ4kOGueA4w2Da9qXHY2gZg2kuI1PXNNRfQXDrD9kqAwjkkk
         CqWQ==
X-Forwarded-Encrypted: i=1; AJvYcCVETzKciG6mc192/13qeuVuzUxkrXXGjJTB+jUZSBwxnH6mkAmcMNh91SrwlFs6msVziSHsQEJBhNlo@vger.kernel.org
X-Gm-Message-State: AOJu0Yze+f6/xWcU8VKKaCGWGgCyP9FnHscxiUhsetP32kYoFpYc34M9
	0rAMjHmd0FTyyolotPmSNRbFZll9P3lrFG8Zu/KeOU6mJqfmY4U2nOU/WFBdBT/yuL/AqddyyU4
	wfkdS9sYvgigHIcRX3NhFlSUGMEQh71tG7hUNQpexoA==
X-Gm-Gg: ASbGncuo7d8A6cUSLi1aoUXnOlBytYpRHYplW/sDpxovE07INGGLsAB/GTk2PGkotAq
	C83Vt/K2YhT3uKw8vD2YxdOHOi6EZ46jwMp0KxY2t8a1QCJAE8IxlykZ6Z3P3I7Q0CPOiLSdX5A
	+z4SvXd8Ha0VWsA77t6SfHnPLdGdBRln5K5PM3Q4HjVIzAXyHE0ZVltKm2cETzhW7Oq1QxhoXXE
	TH4nELrLaE66JhM061BjQDUqipGLDXAjLz2VzL8D0C/7z4=
X-Google-Smtp-Source: AGHT+IEgewShkTB3IO6iy5D1trv7nKdXbV9WtwtBpgyTEh9TZKuca5Qb4ed3HJ87AvQ3ZW2yo7J0WCyjmW8j05mLxIk=
X-Received: by 2002:a17:906:7309:b0:b04:5200:5ebe with SMTP id
 a640c23a62f3a-b1bc1ed67femr266992466b.54.1758115405633; Wed, 17 Sep 2025
 06:23:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250917124404.2207918-1-max.kellermann@ionos.com> <CAGudoHHSpP_x8MN5wS+e6Ea9UhOfF0PHii=hAx9XwFLbv2EJsg@mail.gmail.com>
In-Reply-To: <CAGudoHHSpP_x8MN5wS+e6Ea9UhOfF0PHii=hAx9XwFLbv2EJsg@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 15:23:14 +0200
X-Gm-Features: AS18NWBL5l4pIlkCFqkI5FbYZctT10PlbPlrGgAIhMPZCsLLpTd8MK5AI9j4JqQ
Message-ID: <CAKPOu+_EMyw-90fvNXXRHFpbi8FDc=fd1kGs21iE9+M4ZZSWeQ@mail.gmail.com>
Subject: Re: [PATCH] ceph: fix deadlock bugs by making iput() calls asynchronous
To: Mateusz Guzik <mjguzik@gmail.com>
Cc: slava.dubeyko@ibm.com, xiubli@redhat.com, idryomov@gmail.com, 
	amarkuze@redhat.com, ceph-devel@vger.kernel.org, netfs@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 17, 2025 at 3:14=E2=80=AFPM Mateusz Guzik <mjguzik@gmail.com> w=
rote:
> Given that this is a reliability fix I would forego optimizations of the =
sort.

Thanks, good catch - I guess I was trying to be too clever. I'll
remove the "n" parameter and just do atomic_add_unless(), like btrfs
does. That makes sure 0 is never hit by my own code.

