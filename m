Return-Path: <ceph-devel+bounces-2225-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 47C9D9DC039
	for <lists+ceph-devel@lfdr.de>; Fri, 29 Nov 2024 09:06:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0BD7D2816B6
	for <lists+ceph-devel@lfdr.de>; Fri, 29 Nov 2024 08:06:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B0361581E1;
	Fri, 29 Nov 2024 08:06:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="DgZSLo6f"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D4AC15098B
	for <ceph-devel@vger.kernel.org>; Fri, 29 Nov 2024 08:06:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732867581; cv=none; b=Tj5tYSQ+hApQO1teRd9rf42q+Rti7pdyIXNIJuT4JaMgTxTtdd+qLiLk3bjhZl0jNZNd/5YbmKdIQbuPCK3ub2WHdr3vb3IZIN/sD+of5hAPmOdZtnj54VkBHw4YyUEXEzGQnytj8Y/G6Y9FXUj131hxRckPqxogv9IHiHJvNpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732867581; c=relaxed/simple;
	bh=xdCc7So5WJlPDQV9tqtG5m+9pg/vhfSFOA4sIRrWx7g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eeg1WeIhi1qRiPeFcYwIJNeJkwe2wgT0lXAdhKJ4nkU/SRM17X7D8FwHiCw1N4bYZ+SRutAa6oUBK5e0H4/klbW9R/MNaoA3JBGVMh0ZGU/vpNIyOlB9PduxR44nOBWc8tPKHztFEDv3adDvIlLc1fYVpsgrtPheazPmoimbGdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=DgZSLo6f; arc=none smtp.client-ip=209.85.218.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-aa54adcb894so184211666b.0
        for <ceph-devel@vger.kernel.org>; Fri, 29 Nov 2024 00:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1732867578; x=1733472378; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xdCc7So5WJlPDQV9tqtG5m+9pg/vhfSFOA4sIRrWx7g=;
        b=DgZSLo6finV0NMFXlYdFweErnW8qpOLo5kRxIkGgnIIZ8gcVF5bBoFT/efZRT8lUu7
         xL3d0kAWfjHsGfwba50cG6Tyh2h19ovvJuX6NCVsO8oTKmQ95lW4Ry4U60VG8kVeeLlP
         mo6aOBsr/rFDXZj2AxDc2kPGteNnXB2LshgLA4my56t88qqxKKnHvY0PgMCs62OxCf9e
         M7PvOsWEkpklDYlNba+zJiQ6824wPpQnTrg14OpBH3CqNff9sMT85OXvEM7S6C0txj4G
         2WjEMvHeIDsomS76u7ONQXlY7JQQf7MlzHCEwL53foo2gRJN9ncmehTQJDy0CaQKnUOw
         njJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732867578; x=1733472378;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xdCc7So5WJlPDQV9tqtG5m+9pg/vhfSFOA4sIRrWx7g=;
        b=Lm8ZUFqKUK8mXWb25qFy2ub3qQ85LGLeswXpw/p9GIcZTKSbXwqHYMbquPjoulEuB+
         SxksDfNXZ45gnjahV5qs5JiRJgtEaRiT3N5ORUNXO2yxfWacwxbsPlj6HzGFYvpfHWeD
         53fgEVlG6LsieZdZwfIBVrvpIEe3KSWEC5jlQKe+LEhQXFRRjfKQxJDj3X++uOAxILuS
         iC5SHcIbgYtbq+JZ1maXIChqfu/qBep4rMlS5R/U0IjZtaE+ijDvsStUN4TTjtgBbyZ6
         cpBe2UfcuXPs5An93ORmZuLyo/+jRHymVicyDzWdecLZWVhvVm5eNmqNKO4iwlmzSkvK
         52Pg==
X-Forwarded-Encrypted: i=1; AJvYcCXSmkiyCsad+uBTvL6FCxqO6rUBsAjUFDzXjUdLiOVgX5bDhlW9fF47cZAANuQ+ofWVeFPmsUQhe965@vger.kernel.org
X-Gm-Message-State: AOJu0YwYj3DjmPlM7raqLhWdxHbMdjVhj26IHnrBXXEUq9gbmD2Aog1D
	r8IOQkdSEzSPq6tfhyIu1gZOdVHAGcDCEexCC4HHK/pNZ1XDTrEgWvhOYai700IVi79PBZl/W5W
	N7VwHrKc+0uEcseUYTB1unQwliDlfOSWpF4JBnQ==
X-Gm-Gg: ASbGncvouhcQYpYvSHNiFcRHNaIDaHQKiz/oaK0PNXNbhWQb/HTwcGkaXUUU5qIyj88
	+jnKhhrN5cminr1xszo/6WZZv7rXW/IiDkik/gX++wDOMVDrwH1HhiVBX7ANI
X-Google-Smtp-Source: AGHT+IHvfYEqHD35f8UnLDugHPxFfBJiHJYV9810UXcLgYjqc2ISSIJrK1EXM5GwIAW4E5UPnf+3ZjJlrOLaI3o+G14=
X-Received: by 2002:a17:906:1baa:b0:aa5:cac:9571 with SMTP id
 a640c23a62f3a-aa580f4c51amr744110066b.28.1732867577853; Fri, 29 Nov 2024
 00:06:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241127212027.2704515-1-max.kellermann@ionos.com> <CAO8a2SiS16QFJ0mDtAW0ieuy9Nh6RjnP7-39q0oZKsVwNL=kRQ@mail.gmail.com>
In-Reply-To: <CAO8a2SiS16QFJ0mDtAW0ieuy9Nh6RjnP7-39q0oZKsVwNL=kRQ@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Fri, 29 Nov 2024 09:06:07 +0100
Message-ID: <CAKPOu+8qjHsPFFkVGu+V-ew7jQFNVz8G83Vj-11iB_Q9Z+YB5Q@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/file: fix memory leaks in __ceph_sync_read()
To: Alex Markuze <amarkuze@redhat.com>
Cc: xiubli@redhat.com, idryomov@gmail.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 28, 2024 at 1:18=E2=80=AFPM Alex Markuze <amarkuze@redhat.com> =
wrote:
> Pages are freed in `ceph_osdc_put_request`, trying to release them
> this way will end badly.

Is there anybody else who can explain this to me?
I believe Alex is wrong and my patch is correct, but maybe I'm missing
something.

