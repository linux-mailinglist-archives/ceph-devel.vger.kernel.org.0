Return-Path: <ceph-devel+bounces-2251-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C9E69E553B
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 13:17:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4DBD0287A50
	for <lists+ceph-devel@lfdr.de>; Thu,  5 Dec 2024 12:17:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAA7F2185A2;
	Thu,  5 Dec 2024 12:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="EwG8IKNx"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BC1217F24
	for <ceph-devel@vger.kernel.org>; Thu,  5 Dec 2024 12:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733401050; cv=none; b=Yyh3IeAjEldvW2gahFYtlwKmjJ5ATnMT4TFhmWjjabASBQEc7SiyBxKgWyebiDkZba7iJuvr3wC8mnuF444y1ADfmO96Lldk4ZtKvPSgOlaHk/JbYRp28XN5C7lk3KGsx3+KInGhmgVaQBB8EM6fFnDBkU8wjx5lIn6NVP+sN9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733401050; c=relaxed/simple;
	bh=78ORj5MT7/pCML0JdAvmPGsZjpcS39rBDcRK9aTcAp0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=h/wMtCUO6XyD80Ss7EeEpvYD6IATIF3LMbTbJJoBVpGt0aKpRz2J6M1raS7u8u4LIp/7IbOfJpo6ZrsoavXjMz8siojSt/l3b8s1EXIBxoWmwsRlDgbsj2nbG5QwgkMv8F6ZdpglDQuAQ9R9xiQLuEDQvtPAR0OHF9f+QAUNb0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=EwG8IKNx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1733401046;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=78ORj5MT7/pCML0JdAvmPGsZjpcS39rBDcRK9aTcAp0=;
	b=EwG8IKNxAMyk6chq+08knrMVD8v4Q5/Vz82JK9yK9E3KNDZNwSs35NX7aMK9vQVQm9cgJM
	iVhUFtVGLVZWPon1rfhNVliOfB9otZxjpJij4beN/oPHXTR9AMCTd2Dp1knuPJXXwSvT4B
	pa9CXE4gbt4/mvmUrFRReaN/eggWovg=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-OuMrXZSZM72_7RSlEtA0TQ-1; Thu, 05 Dec 2024 07:17:23 -0500
X-MC-Unique: OuMrXZSZM72_7RSlEtA0TQ-1
X-Mimecast-MFC-AGG-ID: OuMrXZSZM72_7RSlEtA0TQ
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-5d0d0a5ae15so552971a12.0
        for <ceph-devel@vger.kernel.org>; Thu, 05 Dec 2024 04:17:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733401042; x=1734005842;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=78ORj5MT7/pCML0JdAvmPGsZjpcS39rBDcRK9aTcAp0=;
        b=K0O1vns0xqSVz8XLiRdMe7DjyV4S8VJcK7pCRI0jhf3c2cnbFrM9QhrjQAOvUo5SaI
         3dMQnoLmhcWtF+3SB7minW03p+iNrv+ISrL3PpkP1c023z1O9dJ8YcyBnkwyIkbrL+j+
         84Bzx+X6GFOxu3M7Ub6RNHfiPWYik4gSUr7MnBZ5WosNx3jiHkkccXxly0AwpbZT2jYV
         p7v2xMN07otp4YdbKvmQ5eR45N7eY16QnwWzQeEh/GOsPnZMLybDIye5FwWqspdBPls3
         Ya9Y0WNmPfHV5jKGu9nH0QZpbG9W9MDAZ/DqfClAylmOnpwiHfvuJBR79RefuAeTRX1Y
         2mUg==
X-Forwarded-Encrypted: i=1; AJvYcCX5lfFowdRASt2bbkkcCdPmqxf3vDauW1e1YBAQ1VLs5MkXvabtZzUEkTEwDYVp4K9NhNXxUdCJFAlp@vger.kernel.org
X-Gm-Message-State: AOJu0YxhY8OJxPkKqriReuT+qA6F66PF5NKYzMjYB2cztsHhmfZum0yB
	ELl9p9/Vj7V068P/WjT89tk+hCtuYlf/cpm6X41wZMm/vBLuPZ+B4rTy054L4M5J2Xp+OgIvm+S
	F7SkAa3I4CT9GlAwlWbNDdLruLmGLBbrZNOv9TiBatF/gXuZHZZu95DGutIQqzztgFp3f7GcJXh
	cVWBeaCFv5HeLdLPSJJPOWhBrIvMW4cXfmOg==
X-Gm-Gg: ASbGncvWC393g3A3jPbyzW4Lhgffk//JMu19j1ggyPrDANg/DWgQBWgoWcyRCmJnrH8
	G7byKHHJKMsgoB3Zug+uHjpLMc9963XYa08dbqAtZSl4raCZrCA==
X-Received: by 2002:a05:6402:1e91:b0:5d0:a80d:bce9 with SMTP id 4fb4d7f45d1cf-5d10cb5bf71mr6852855a12.20.1733401042225;
        Thu, 05 Dec 2024 04:17:22 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF3iXCeT32h33RCPB/Nuod7nzqqUOSinEmle6v0DZwf71ur+JzfVPYQboWjeRhNIDMCipSgjS8it6mvXG5oPag=
X-Received: by 2002:a05:6402:1e91:b0:5d0:a80d:bce9 with SMTP id
 4fb4d7f45d1cf-5d10cb5bf71mr6852840a12.20.1733401041869; Thu, 05 Dec 2024
 04:17:21 -0800 (PST)
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
 <CAO8a2SiTOJkNs2y5C7fEkkGyYRmqjzUKMcnTEYXGU350U2fPzQ@mail.gmail.com> <CAKPOu+98G8YSBP8Nsj9WG3f5+HhVFE4Z5bTcgKrtTjrEwYtWRw@mail.gmail.com>
In-Reply-To: <CAKPOu+98G8YSBP8Nsj9WG3f5+HhVFE4Z5bTcgKrtTjrEwYtWRw@mail.gmail.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 5 Dec 2024 14:17:10 +0200
Message-ID: <CAO8a2Sio-30s=x-By8QuxA7xoMQekPVrQbGHZ92qgresCDM+HA@mail.gmail.com>
Subject: Re: [PATCH] fs/ceph/file: fix memory leaks in __ceph_sync_read()
To: Max Kellermann <max.kellermann@ionos.com>
Cc: Ilya Dryomov <idryomov@gmail.com>, xiubli@redhat.com, ceph-devel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The full fix is now in the testing branch.

Max, please follow the mailing list, I posted the patch last week on
the initial thread regarding this issue. Please, comment on the
correct thread, having two threads regarding the same issue introduces
unnecessary confusion.

The fix resolves the following tracker.

https://tracker.ceph.com/issues/67524

Additionally, these issues are no longer recreated after the fix.
https://tracker.ceph.com/issues/68981
https://tracker.ceph.com/issues/68980

I will make a couple runs with KASAN and its peers, as it's not
immediately clear why these two issues are affected.

On Thu, Dec 5, 2024 at 2:02=E2=80=AFPM Max Kellermann <max.kellermann@ionos=
.com> wrote:
>
> On Thu, Dec 5, 2024 at 12:31=E2=80=AFPM Alex Markuze <amarkuze@redhat.com=
> wrote:
> > This is a bad patch, I don't appreciate partial fixes that introduce
> > unnecessary complications to the code, and it conflicts with the
> > complete fix in the other thread.
>
> Alex, and I don't appreciate the unnecessary complications you
> introduce to the Ceph contribution process!
>
> The mistake you made in your first review ("will end badly") is not a
> big deal; happens to everybody - but you still don't admit the mistake
> and you ghosted me for a week. But then saying you don't appreciate
> the work of somebody who found a bug and posted a simple fix is not
> good communication. You can say you prefer a different patch and
> explain the technical reasons; but saying you don't appreciate it is
> quite condescending.
>
> Now back to the technical facts:
>
> - What exactly about my patch is "bad"?
> - Do you believe my patch is not strictly an improvement?
> - Why do you believe my fix is only "partial"?
> - What unnecessary complications are introduced by my two-line patch
> in your opinion?
> - What "other thread"? I can't find anything on LKML and ceph-devel.
>
> Max
>


