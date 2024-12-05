Return-Path: <ceph-devel+bounces-2256-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B5ADB9E596D
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 16:12:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0E8D31883041
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 15:12:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E66F21A453;
	Thu,  5 Dec 2024 15:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gzDlgWLf"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1ABB1773A;
	Thu,  5 Dec 2024 15:12:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733411544; cv=none; b=KOMUoY8gveGQUzXqtfrxAE9aWKjjuwgAtrv6VqlKbfNqkefvC+szboHKlZWViIIPoIvAaVfiPDZElG9fggu9fx3BLHEec7pHdBOsc7A7eh5NxVMK84crXloywOzMz7x92Qh9cHtOO3WNBk9TQxZxFGjrxPs4wN+tVVxCyAKmlsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733411544; c=relaxed/simple;
	bh=3dlwP6R4UeEOch6dvA4PjE6/yt5UNhCqvlpURqq34zs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BGQpr4SCE5b/EwNX7jnsvCRckrgIoQlFAhjwizuxplYLivTIngMCEFUAP6gr3nWkC3xhGHew72IUX3l495p/w5D+IXdLXu3hynQrFa+Eon2Y7rd9p7DU0HDW+NIkdWyXL9DqyAm8e5PwEr3izqhqj04hrV8pvztQOBCBZ/jH5TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gzDlgWLf; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2ee51f8c47dso787979a91.1;
        Thu, 05 Dec 2024 07:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1733411542; x=1734016342; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ta/qpOfvdFG4UyGhcgxlL9R+BfoI6tUfyv7DmOOO2w=;
        b=gzDlgWLf+YEF/z7KqMvv2AYkmTIbruYF8xqBkpg3V3VY3EaXHWJLn3CrdVj3uyui8X
         HGDJzn98qpIxLwWk3weS6RwVqWH4GynhBJgmWdLH3egXcMCmIdvRdiXRL3+4eRUsG3e9
         ZyMG8sHLU6ftRQBB2BGv6Gj0jgS/2AnStr+Spe/0pQDp6nf/NyWg1obIlFqbEqPu6dw2
         8w+K1K1wj+P45luUpq2bp5Yfth45a31EvvOMxFMSacyCNQntt29MOziz4a7nJzRlnocl
         J8sm3Wvua451rVt49JAZcsOvEH0tfVQd4jpj962J3hYsPl+naJBI8QufH8QCMMSGanhw
         6x2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733411542; x=1734016342;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9ta/qpOfvdFG4UyGhcgxlL9R+BfoI6tUfyv7DmOOO2w=;
        b=UEusduPTDKOc0Jkyng5mnCS9Izg1DQkLVuXgjMV9Tp6IMvROnciDa9EhF7Qq1HqvlI
         QDYdp1pU907kf76H8uvYvBZiCv2bEQqpjcrhCFIOadFNJDVLXb7u/4wiQamP9Gp1MjR1
         ElR92TKqSddmc9NCag8kV6k4VchKTGD8yTi5oWyOXSBh21jfMzBT7zBL/nxVhDMBYR2p
         sn+S9+o4PpkZ0PbIsvn2yiu7G/HRIcZUGMg237mxd6Ij723z75B2Eb1xVCtckT6ydzC6
         WZkxXlI3JXd/Q/g3yqXhjUGKCrVIt3f6wdT0kQIScNQnseG7oJiSquPFpDAz0I7CvWEY
         itxQ==
X-Forwarded-Encrypted: i=1; AJvYcCUBYF/Zw4+0FXsi5UjHAcCVkspkSPmy/xk3yyU44gP/IvVQVnC69SFGYhXx/WpKhBysFvIjFZZ2YLsCBCQm@vger.kernel.org, AJvYcCW3jAVSt+rFeeukQeL50iruvs5FR5Ht0dm6CR/++AOuhP5JG8tIoX4Km0lvXxdpWRQ2t4tdZiNd@vger.kernel.org, AJvYcCWSmfRQDohHWm6DcK93kEf5kmd65/naprTcPA3nuIZSvNTGJLOaNbNcuthCHh4gsUZTpru5FtQ3dYvq@vger.kernel.org
X-Gm-Message-State: AOJu0YyuTsZDY435846IhuBkmWvUHKmW495baHBp1FYhzzVf4xlq42lK
	Tqd3QwjJRMrt2Ji8pbDK3TjNFgulRsba+pV8vrxHBuoEMzRd92Rh3wKdRKj7sPt1/DDaIST1nsU
	3cXDM+KwuD6o8cNsMErRPLvfByPA=
X-Gm-Gg: ASbGncsfzeV/Yb17z+YAhA5Mx5Yt88qk3Yl8uQ5xTImZ6mQtt0HjJWyUOk9Y2UmkmDY
	xvYbYyva1iDKAGkHU6HGDA6D3faMAh/4=
X-Google-Smtp-Source: AGHT+IEeyZkTwvBN7EWjDtYwzRLbUUJ5eG8UgfY9Yz6Tgwo52TY3MzQDeXi8tUF0oLpS0JI6tQ7BZzr9MF4bcUl/z0Q=
X-Received: by 2002:a17:90b:1c07:b0:2ee:96a5:721e with SMTP id
 98e67ed59e1d1-2ef011fb843mr18642704a91.12.1733411541877; Thu, 05 Dec 2024
 07:12:21 -0800 (PST)
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
 <CAOi1vP-SSyTtLJ1_YVCxQeesY35TPxud8T=Wiw8Fk7QWEpu7jw@mail.gmail.com>
 <CAO8a2SiTOJkNs2y5C7fEkkGyYRmqjzUKMcnTEYXGU350U2fPzQ@mail.gmail.com>
 <CAKPOu+98G8YSBP8Nsj9WG3f5+HhVFE4Z5bTcgKrtTjrEwYtWRw@mail.gmail.com>
 <CAKPOu+9K314xvSn0TbY-L0oJ3CviVo=K2-=yxGPTUNEcBh3mbQ@mail.gmail.com>
 <CAO8a2Sgjw4AuhEDT8_0w--gFOqTLT2ajTLwozwC+b5_Hm=478w@mail.gmail.com> <CAKPOu+-UaSsfdmJhTMEiudCWkDf8KU7pQz0rt1eNfeqS2ERvZw@mail.gmail.com>
In-Reply-To: <CAKPOu+-UaSsfdmJhTMEiudCWkDf8KU7pQz0rt1eNfeqS2ERvZw@mail.gmail.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 5 Dec 2024 16:12:10 +0100
Message-ID: <CAOi1vP8PRbO3853M-MgMZfPOR+9TS1CrW5AGVP0s06u_=Xq3bg@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/file: fix memory leaks in __ceph_sync_read()
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Alex Markuze <amarkuze@redhat.com>, xiubli@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 2:08=E2=80=AFPM Max Kellermann <max.kellermann@ionos=
.com> wrote:
>
> On Thu, Dec 5, 2024 at 1:57=E2=80=AFPM Alex Markuze <amarkuze@redhat.com>=
 wrote:
> >
> > I will explain the process for ceph client patches. It's important to
> > note: The process itself and part of the automation is still evolving
> > and so many things have to be done manually.
>
> None of this answers any of my questions on your negative review comments=
.
>
> > I will break it up into three separate patches, as it addresses three
> > different issues.
>
> ... one of which will be my patch.

It looks like Alex's preference is to address these memory leaks by
passing true for own_pages to osd_req_op_extent_osd_data_pages() and
adjusting where the OSD request is put accordingly -- this is what he
folded in his WIP patch which was posted in Luis' thread [1] the day
after this patch and pushed to the testing branch earlier today [2].
Unfortunately an update to this thread was missed, leaving everyone
including myself confused.

Max, would you be willing to redo this patch to pass true for own_pages
and post a v2?  There is nothing "bad", "partial" or otherwise wrong
with this version, but having the pages be taken care of automatically
is a bit nicer and a conflict with Alex's ongoing work would be avoided.

[1] https://lore.kernel.org/ceph-devel/CAO8a2ShzHuTizjY+T+RNr28XLGOJPNoXJf1=
rQUburMBVwJywMA@mail.gmail.com/
[2] https://github.com/ceph/ceph-client/commit/2a802a906f9c89f8ae492dbfcd82=
ff41272abab1

Thanks,

                Ilya

