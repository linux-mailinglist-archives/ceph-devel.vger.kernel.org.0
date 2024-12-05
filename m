Return-Path: <ceph-devel+bounces-2257-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D58FA9E59EB
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 16:40:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 80A87169B42
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 15:39:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1AC2B224AFC;
	Thu,  5 Dec 2024 15:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="WnYMLLp1"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71C49222560
	for <ceph-devel@vger.kernel.org>; Thu,  5 Dec 2024 15:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733413053; cv=none; b=mmNhb9E4PSEyEC5UbA8iuyNBFWNNYG4kk1EHVJR/q9/Ln9+QE+epUGZ1+EnqQriZuqe2drfayIVjCboMJL3h9EmPZBoLYwf3wOTPGQ+fZTv9JdS6FcDmUybfG7r4T2s/Pepi/RSPExxgdgIM/1vBcfmJxbRG5T2k2EEHyj0+RJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733413053; c=relaxed/simple;
	bh=JNrJE4PNKWi4PgS2zzJNj42RXg3+tnZcjkDrm5MlRZo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I2wVLt7IHhKR9Q/FdGXmTAIO4WV9X+UZedzAjiy7LUUbOAvL1nkK6qkvECJRWLz45csb1p2XiQYF9g2ggWSfJVWLex4ZEW3SL+i54OC72Ek6j1a9Tvve/QxjEybzhJh4inClpDOiAQvvgJ///8H279irESWC/AW0X+9yiVP2Z94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=WnYMLLp1; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5ceb03aadb1so1393855a12.0
        for <ceph-devel@vger.kernel.org>; Thu, 05 Dec 2024 07:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1733413049; x=1734017849; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=udUgQDGNdbMPWrJLGwmC+iYf+bG5pC2AYc0h2JBRvvw=;
        b=WnYMLLp1WjvoBsTXPh3vkFRTyM5cK95FmKUXIbdd2p1FGkUotlrIndvOufIAb3H19b
         mTvD1xa0YMBs1bLG5UiGZdnCgemKxzgSyzMN3AivnhuC0HSCHkmVf9huDkRnKjnF+IBI
         5z+pi/0YhNV1DBO6tBOOOsLfFKtOeG8mZ6nrYgrVL/TMGAlv/HVhg7b+vcTZNly3XDq5
         /FUS6wRxRnDZDzX1QIqHP1Rm6gEX1w1XgAb2ENydR9c69O9QgHP0R2dr0RunYSvtxQMY
         mIkudEjz2QqcJ4ldOOWF45HJq89c2bdbsLFpeTy8KVpFTPQVVXuUBOoSm+BUc1b0/AB7
         Wqxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733413049; x=1734017849;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=udUgQDGNdbMPWrJLGwmC+iYf+bG5pC2AYc0h2JBRvvw=;
        b=XlY21qmDjEIB2Pw2GZhvxFAP8js8Sc8rAJplmSOl0EUbOMsuk5k7t8rt36sWpoRY3o
         lXvvtC/ptHAO1KeRqTiPpgeLu/Zb8CWccgPL3Ubo/Hk+v2QLFNYEXBIwN2+yq2L3qrf4
         xjOVhkPeS+oWJTAZl331ynZC5F6XUWhc7EfaDEZJ8UsaJ5q++aQz7iB2I4Uus1Jz5IJ0
         glVvRMslUr8HsJJGbmRhkHNLGg19qG3sFME4Uv3ST+AjikZ5w5nVIgMTF4LSM1Zu/ElU
         NdcTpyNAYYGv4e3dXE5lWs7hAW3X1Uxv5rVRJFjyb09Sv9kulsQxwehRa43BcrDDTU89
         QzHw==
X-Forwarded-Encrypted: i=1; AJvYcCU17Nb1V0iaFdmWGM1hgk2RARkCm3GCJgryr+02f6lnRaLskpaGBRz6L/KIJ6f8BKcsPBH9QZE8bamE@vger.kernel.org
X-Gm-Message-State: AOJu0Yxq2OOcSxITtBTShlNtiO5G9Z5pFx61HZftzuPeuf0fnjV/su4s
	hjksfRC0MzgEh5iSOh3HbPekzXoW7t4Ce09i06wip4uRue6EtcaBOfvQk2fVND2vW/PVWWZawO3
	aDdj+r/nBTiSD1ifdFARFMbcTjgbCQsjPNY17jg==
X-Gm-Gg: ASbGncs7TXUegADCVe0yhAkehX5TeBR/Km4ojCAecG08GwzA3/U+nkL5wOcKq1O/LPD
	a82h0NGcRJ4eLcUqKGkAOE8086R9VuTuzZsjfwensvc6MprTRuoeCDIAZ/IxD
X-Google-Smtp-Source: AGHT+IGEKXx+46UOY0lk1kFYEVr3spOj2UG1T/8pmt0vJkhgJLp4zvDKJOhOMmQCNljzjITZmsXudAKntczvHQzwFyY=
X-Received: by 2002:a17:906:dc8d:b0:aa4:e18e:1ca9 with SMTP id
 a640c23a62f3a-aa5f7f2acd4mr1098076166b.60.1733413048798; Thu, 05 Dec 2024
 07:37:28 -0800 (PST)
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
 <CAO8a2Sgjw4AuhEDT8_0w--gFOqTLT2ajTLwozwC+b5_Hm=478w@mail.gmail.com>
 <CAKPOu+-UaSsfdmJhTMEiudCWkDf8KU7pQz0rt1eNfeqS2ERvZw@mail.gmail.com> <CAOi1vP8PRbO3853M-MgMZfPOR+9TS1CrW5AGVP0s06u_=Xq3bg@mail.gmail.com>
In-Reply-To: <CAOi1vP8PRbO3853M-MgMZfPOR+9TS1CrW5AGVP0s06u_=Xq3bg@mail.gmail.com>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Thu, 5 Dec 2024 16:37:17 +0100
Message-ID: <CAKPOu+-CpzPaY28MH9Og=mZTYmu99MUFTs+ezDZvud0HVb9PAw@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/file: fix memory leaks in __ceph_sync_read()
To: Ilya Dryomov <idryomov@gmail.com>
Cc: Alex Markuze <amarkuze@redhat.com>, xiubli@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Dec 5, 2024 at 4:12=E2=80=AFPM Ilya Dryomov <idryomov@gmail.com> wr=
ote:
> Max, would you be willing to redo this patch to pass true for own_pages
> and post a v2?  There is nothing "bad", "partial" or otherwise wrong
> with this version, but having the pages be taken care of automatically
> is a bit nicer and a conflict with Alex's ongoing work would be avoided.

Yes, I will send a patch for this. Even though I don't agree that this
is the best way forward; I'd prefer to fix the leak with a minimal
patch adding only the necessary calls, and not mix this with code
refactoring. A minimal fix is easier to review. Mixing a bug fix with
refactoring is more dangerous, which is important to avoid, because
this patch will be put in all stable branches. But ... if you want to,
I'll do that.

btw. Alex's patch
(https://github.com/ceph/ceph-client/commit/2a802a906f9c89f8ae4)
introduces another memory leak: by postponing the
ceph_osdc_put_request() call, the -EFAULT branch now leaks the
ceph_osd_request object. I'll take care not to make the same mistake
in my v2.

