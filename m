Return-Path: <ceph-devel+bounces-2246-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ACB6F9E4F9F
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 09:25:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 33CCB1881AB9
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 08:25:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2EF9A1D3566;
	Thu,  5 Dec 2024 08:24:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="bDMJAuVg"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3621F1B0F0E
	for <ceph-devel@vger.kernel.org>; Thu,  5 Dec 2024 08:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733387098; cv=none; b=psV/3VmIdo6MkRnz+toZTO5ZqTBKgOK7eiqDGsY3Qq5I52o58FAI4GbbQ982kXrj1M0I/K/TZSfHnybiMGDJ0C8/ihZmgFTXa8+jAtebWJYItrcX2whPFYYXLovL3EB2W4oIxTnjtZvFS3VX9cfeSFNO4uD4cYklYQ6dnNdnJtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733387098; c=relaxed/simple;
	bh=Uo9k1X5K3r3Hc4fiemmVrrIOCep2IwuCxnhIE0FNAZs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GMvCSYnUw3QGZ8y2mPk9vcQzB16eYUfcR1arPtjC97s3S4J8xLgqt9RqGWVuwPMYjIE8OsZQzwe+uNj/wbNX7GriPOynKitGm6FT7RNXaaC4wgzrY1lswjVAefIlsjUY5PQBb6Lr7qGtuK670z4TGwQc4vifkEwzdBFiAiIBPVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=bDMJAuVg; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-a9e44654ae3so90285466b.1
        for <ceph-devel@vger.kernel.org>; Thu, 05 Dec 2024 00:24:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1733387092; x=1733991892; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uo9k1X5K3r3Hc4fiemmVrrIOCep2IwuCxnhIE0FNAZs=;
        b=bDMJAuVg6R7OCggMtjkmf24FjME3urx061rEFQBtX3Sw48SehiFotTnOBEMMcbge6a
         D9y5s1rbiN96e5I8Gft8ppRn8/DH4sqCluiBN30mBiCL6KKpn+su0WQ4OWyFMmGMATJX
         6jRyz6nqrXfhK+ISlQngJb8lI54OpCMe4tz5B+yxhEUfWdveTZ/kWjo+QGICE4eZHQ97
         ARR2QVVKKZ/7KSYIKhpFCOgZwDwXSGptBwThI7YLOwmTnWSMUgFJeSO8LVTA2ys1mt6B
         zXkEV1wWlCRx3z6MO0VH3jEiHlMEVGQ/+FUd709bOcvS4nz3PuJPnP9PLPJdBv8FfURL
         NVSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733387092; x=1733991892;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uo9k1X5K3r3Hc4fiemmVrrIOCep2IwuCxnhIE0FNAZs=;
        b=l3MnvpjlgdVL9jdEwajoFQ6DjmKMumCNcMbWc0LxniN68iIqSH/hURbPiDw3Fin+aH
         1aWzMij5NkZV23tX6eY3yZl5R1R+QoFZOEe5yK9qDSqbO4o3uFq8nRFfEWWiL3mZwm5Y
         iN6GuTiEw5ZCZOPUsbOufoRUAvBtwjr+7fvRPZzzBLIawrAPOE8amHE4FsfTZnFLcXby
         IvJqHDWu8X383TrjB4XX5tfCg6ZJiLHA/StmLpcEPwxCgrLDmZuxnSIhYNqvxxAgpvWD
         7l58JBpQHtE3nZnrcb6PhZxsNLfqaPJI6P+Ed6ZdVGml8bOoOCvE7i8rYHxmbBc1uzq/
         eeCg==
X-Forwarded-Encrypted: i=1; AJvYcCW6g6f1i+xO7gF/tvZIQFE6FTem1Ab5hMxY1oxtn5t/A8Ob/EfSWPVYWr1Yperd1aA8q4mgCUiWGUdq@vger.kernel.org
X-Gm-Message-State: AOJu0YxLVBIfzWAIMDWW2/ELtBSB6YJhNPgubVkZobRZCCo6yaZglvMh
	TV82s34SOeIcTiu+tQJ9E1IYTf04saQj7IG9V7z1onmnGtuXqTdOQC5mVNkMjNOjW1m9bYefKGs
	8nRJLFtBnw81VNPJv5FlsuSHelGYydvqY0s9kLw==
X-Gm-Gg: ASbGncvAJsrsS1CRrBoKtAtnpQmOEqP7STFy7J+iKSFmcPe6t6uIJCnMXNbBXdqMY8R
	xIvDTOH5ggjVLiN6TL0WkbLc+OgOOdhYf2JZQj/UHcuT9mPZVShWhiS7YyeuD
X-Google-Smtp-Source: AGHT+IF2FUmzqqeTqCOHliK3GHeSyqq90+/gTLGnQGE6+L+NEFrr+o2g/bwcOvlBUZndiM7KCRfcrc2i2XJirDHBN4w=
X-Received: by 2002:a17:906:3ca2:b0:aa5:1c60:39ba with SMTP id
 a640c23a62f3a-aa5f7cc2f2fmr781184466b.6.1733387092618; Thu, 05 Dec 2024
 00:24:52 -0800 (PST)
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
 <CAO8a2SiN+cnsK5LGMV+6jZM=VcO5kmxkTH1mR1bLF6Z5cPxH9A@mail.gmail.com>
 <CAKPOu+8u1Piy9KVvo+ioL93i2MskOvSTn5qqMV14V6SGRuMpOw@mail.gmail.com>
 <CAO8a2SizOPGE6z0g3qFV4E_+km_fxNx8k--9wiZ4hUG8_XE_6A@mail.gmail.com>
 <CAKPOu+_-RdM59URnGWp9x+Htzg5xHqUW9djFYi8msvDYwdGxyw@mail.gmail.com> <CAO8a2ShGd+jnLbLocJQv9ETD8JHVgvVezXDC60DewPneW48u5A@mail.gmail.com>
In-Reply-To: <CAO8a2ShGd+jnLbLocJQv9ETD8JHVgvVezXDC60DewPneW48u5A@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 5 Dec 2024 09:24:41 +0100
Message-ID: <CAKPOu+-d=hYUYt-Xd8VpudfvMNHCSmzhSeMrGnk+YQL6WBh95w@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/mds_client: give up on paths longer than PATH_MAX
To: Alex Markuze <amarkuze@redhat.com>
Cc: Patrick Donnelly <pdonnell@redhat.com>, Jeff Layton <jlayton@kernel.org>, 
	Ilya Dryomov <idryomov@gmail.com>, Venky Shankar <vshankar@redhat.com>, xiubli@redhat.com, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, dario@cure53.de, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Dec 4, 2024 at 1:51=E2=80=AFPM Alex Markuze <amarkuze@redhat.com> w=
rote:
> It's already in a testing branch; what branch are you working on?

I found this on branch "wip-shirnk-crash":
https://github.com/ceph/ceph-client/commit/6cdec9f931e38980eb007d9704c5a245=
35fb5ec5
- did you mean this branch?

This is my patch; but you removed the commit message, removed the
explanation I wrote from the code comment, left the (useless and
confusing) log message in, and then claimed authorship for my work.

