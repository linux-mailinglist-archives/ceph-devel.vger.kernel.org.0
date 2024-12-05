Return-Path: <ceph-devel+bounces-2247-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C17D9E4FC3
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 09:32:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 36EF61881FF2
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 08:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88EC61D416A;
	Thu,  5 Dec 2024 08:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Lw6zYR8U"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B8D1D358B
	for <ceph-devel@vger.kernel.org>; Thu,  5 Dec 2024 08:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733387565; cv=none; b=psRNzRkD0W5ZaGLnTqcp5JrrBBCwMDYDXE+aiN1OELDaM4un5zJo64HGUSz4WuvsCA/YuAlG6GvcjSBrW8D8xHKKh0Zal5XgUZ1AMfqbXRjuSQM2C76DufdbBRCkvOJSVZj5f6BD8L494d4Cy0xaLc/O+tbbig5GQD/mCqy2GcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733387565; c=relaxed/simple;
	bh=EJPt+tqdGiqNz0PpQpFiRahH0cHhTtaiS3IKrYJT9bs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sgn12z9TBoEUXQNtAkvTpriYIJ/a111gslmHAUSFbej0IcCR4SfCapsxBYkMMIm0MUGt0XaA1dgh32Ph9P1zmMIrnRjN9ZOFCpnq3sBIh86XGC/ij8KcqtFN/80Sk8Q2JgeXHQXfxiGRlHn9TNS4z9tMVJ3uNpBzV/oasJdCVy4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Lw6zYR8U; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-aa62f0cb198so5428666b.2
        for <ceph-devel@vger.kernel.org>; Thu, 05 Dec 2024 00:32:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1733387561; x=1733992361; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EJPt+tqdGiqNz0PpQpFiRahH0cHhTtaiS3IKrYJT9bs=;
        b=Lw6zYR8U68nIgqAW60VowqgddjDSCaZ55oSvj67SHUBD553XkGx4FeFDutJjgnwADp
         cRaViBRSpDgTjL7VVC2OU0qykFVWFJtZjPLyCh6cXtFW/xuB9AFbSv+tZ6FeuUSL17N1
         +d2r+sF7MB8v1aDEhf1gQbzlLRN7R6/3rmGscaVHt7QRVPsCvuhOBcWupfvuGkNe5ZLt
         VdN/ixqm0gSyxCvQkmVAqUHvyJmb2Zop9EQgWYPqP/42TSVXQ2gCsa6wZn437z7yB+bx
         CmK9u0FZIMSoWMpGNpgwPjF/FX7zu5K08TQ6BPrjbgG359sulb9zenljQJyIu3QNFTJQ
         UiBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733387561; x=1733992361;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EJPt+tqdGiqNz0PpQpFiRahH0cHhTtaiS3IKrYJT9bs=;
        b=uXmzJYcciT334KT3/dHtNemR31D6HlIvismFkrfBy0ZsFw0VgfMhS9qv9l58XX2NfM
         iZG4oylHdLU9ydUoJm1a8+DtJJ3W/F2dK0VR99wsd1JaZfHKvIsHKbVw4UEhd9ejpviN
         BHG9pw1R9t0qzLZUp6Y3Gkq6oqlpE1OfW3ovuL14IONMVbfviPm4WCRb+pG6z2krf2C4
         u3AClQic7VPO/G+I3cEoKhyQCv9Vg4d1w3GVi1IKEWDHYecFXxntwJwOBHhCzUrSe0wR
         0rxFW2+nCPa/Cj+EMreH6N1dt6NxV8qCibRDWOtmil//Lddpc963khZjRl6Tw/wagfMJ
         x4SA==
X-Forwarded-Encrypted: i=1; AJvYcCVLoN/zWRIyECTY+G1yt43R22DGEAFeJEnLIZtAmkjLeJb3rp0+va6k2dZu4DHZd43SZaf2l3+6mcVH@vger.kernel.org
X-Gm-Message-State: AOJu0Yz4dxVweQzeyjvtYDKn60hjUjVIwK2HGpcwYXxYA/xVHbCxBg1k
	4dIbyY4w6KBPNqWTUc4PSRuxYARbvTrFZhISvDeMaKIfVvKEF9Ec2IAY/RMqBtI+D8KkptTYVc8
	Ezkp6hbisCDJgiyvhHNy0puKe7Ou6WqDNpV/1/A==
X-Gm-Gg: ASbGncuF+cFi/qz34dyb9lwzYbASx3j0b8uUWXzG3wy9Vpd9VK11HX0WxsIFYLmj2k0
	xoDxCWA4XrgPToEdp/TeOZJ/Qvj7sgOhw6hA3dSHnp+npij1iTrMbDGAgLU4/
X-Google-Smtp-Source: AGHT+IEfOOIUAP+qzQLjr/PEbT9YYByWGvZ37kA/qsEDsa9dd02Ei0bVAjizMWSWGf9G5Brf6kG2rT73PAYZKr6E8eM=
X-Received: by 2002:a17:906:9c1:b0:a99:529d:81ae with SMTP id
 a640c23a62f3a-aa5f7f3c39cmr623289166b.55.1733387560655; Thu, 05 Dec 2024
 00:32:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241127212027.2704515-1-max.kellermann@ionos.com>
 <CAO8a2SiS16QFJ0mDtAW0ieuy9Nh6RjnP7-39q0oZKsVwNL=kRQ@mail.gmail.com> <CAKPOu+8qjHsPFFkVGu+V-ew7jQFNVz8G83Vj-11iB_Q9Z+YB5Q@mail.gmail.com>
In-Reply-To: <CAKPOu+8qjHsPFFkVGu+V-ew7jQFNVz8G83Vj-11iB_Q9Z+YB5Q@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 5 Dec 2024 09:32:29 +0100
Message-ID: <CAKPOu+-rrmGWGzTKZ9i671tHuu0GgaCQTJjP5WPc7LOFhDSNZg@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/file: fix memory leaks in __ceph_sync_read()
To: Alex Markuze <amarkuze@redhat.com>
Cc: xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 29, 2024 at 9:06=E2=80=AFAM Max Kellermann <max.kellermann@iono=
s.com> wrote:
>
> On Thu, Nov 28, 2024 at 1:18=E2=80=AFPM Alex Markuze <amarkuze@redhat.com=
> wrote:
> > Pages are freed in `ceph_osdc_put_request`, trying to release them
> > this way will end badly.
>
> Is there anybody else who can explain this to me?
> I believe Alex is wrong and my patch is correct, but maybe I'm missing
> something.

It's been a week. Is there really nobody who understands this piece of
code? I believe I do understand it, but my understanding conflicts
with Alex's, and he's the expert (and I'm not).

