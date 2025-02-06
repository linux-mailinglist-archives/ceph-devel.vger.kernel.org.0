Return-Path: <ceph-devel+bounces-2640-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CD9DA2B396
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Feb 2025 21:50:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 23024167994
	for <lists+ceph-devel@lfdr.de>; Thu,  6 Feb 2025 20:50:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EAFD01D8E01;
	Thu,  6 Feb 2025 20:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KyCSQiNl"
X-Original-To: ceph-devel@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D9021D95B3
	for <ceph-devel@vger.kernel.org>; Thu,  6 Feb 2025 20:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738875012; cv=none; b=UV2vQgdYZ8Sf2EtGhJpd6nC40aKWmNZ4VcsHAb7W6MfRwVfnqiZEaHsvfVn5jFDJLuRdTGJSiQ3jNYQVPcP0hIl0EBb0lRvlqjbVItr2WpbieVv/MJp32viF7e6ab77Iil7PnYt9ozbvxTjZk+1mqqUZAB8X/im1BluvmL4BWy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738875012; c=relaxed/simple;
	bh=nQG33Huz/RJ26x/KpRSxkU5XRcQ9e/a3aCHLb7O4+fk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s1zx7BO4/jOaoSDBc/Nl/9uNX9hEZ/OAWYVLZCI/q07yd6Ne8ov9NHTlPDwSvmYKLVlqjTWRHxA0rVRVa25Adbcv01Q/u+cDB2lf9mfvgMcGqozYzVq5Mx29IvnPYLRnBM0Ki9Gc0B3jDQSfHN+rFlDwwFHDEzve7ChhCU26ke4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KyCSQiNl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1738875009;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2jLFCxHLVjPyBpINbgKuvp8RyvizQvi1+ogCNwnIkE0=;
	b=KyCSQiNl+dmHliIwoB+ZTp+EDcvy2YO4KIOgOny/+i/a+K9EOwXNTBA6UZjce8aWVBDOm2
	Ym9RcKyWUfihUOKGYt2asmJqV9KSGsibfdKsAyhSHVS3gsQfLJ8KVyjWI8kwGCvhNxhed6
	KIGazuXQUWDYTSDxWjcyV6yytuKaeWA=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-QwHiWbajPjKdymAbdxfIzg-1; Thu, 06 Feb 2025 15:50:07 -0500
X-MC-Unique: QwHiWbajPjKdymAbdxfIzg-1
X-Mimecast-MFC-AGG-ID: QwHiWbajPjKdymAbdxfIzg
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-ab6fe8d375eso140057966b.2
        for <ceph-devel@vger.kernel.org>; Thu, 06 Feb 2025 12:50:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738875006; x=1739479806;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2jLFCxHLVjPyBpINbgKuvp8RyvizQvi1+ogCNwnIkE0=;
        b=py8IOJ3v237KM/m/jBBkZmTUZqHnENUGj6lghWV/M3W9c4dpFMUSATmS86sl8geFmG
         ao/GVCldqs2LIwn5+uOqTpQwdqOoJ2ENvp8kHKSkU8P+B71EKut/BfrclShX2AZz+65H
         uj2IcqU+R03sjOY/noKheaQcTboPD0qWQq1YJDdFqgvOaOvzU1gonNQN25NG7YiRi9ON
         8mGpn4X4SK4cFfTUBB3SwncGXVwiMcA7S3sdjJHgrOQuLkQbpa0Kx+J0HAGZ5j7y4Hcq
         Wfh6CyJpmua3Qrb/kquOjJwFEpag9kwgqHEB/JvLy3TR+jIvGl029xKHfYi1muytxS2t
         vVsA==
X-Gm-Message-State: AOJu0Yxmj43X1C6mDK7EQqG6kS2qCn9sKOovjqLm3ATTpZ+g8xcoe8O1
	KgStDxemWzmIJkkbkdzbqizz+z0rryn558Gp5Vz6RSN8sR5vCjz2qe0538jhcAdXYPZjvJ7lutd
	YTsTqTReuxgNF3CaN6PW7sm+mTy44GPZGfaSVFbdBsR95Z0QtAfXxU2IoaNJWCh3jTPnRic5aLb
	tnVT+arejMmp1TssT6jEAtYt/0xBgLvwBqHA==
X-Gm-Gg: ASbGncsRxLScdisqx5fIGvz1ojks9jv8K9OuzL1NIxg/a3UjlpirZV43KWyguWKHtsx
	THre0/l01yTb01fzAVVozWQ1yt8IAfuf6MaItXcR7FT1Bf0FQyd8OFkXeGtN6oA==
X-Received: by 2002:a17:907:3e8d:b0:ab7:63fa:e49c with SMTP id a640c23a62f3a-ab789cbe110mr33653566b.36.1738875006492;
        Thu, 06 Feb 2025 12:50:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGmlPfqCpQklbkFCXxW+VzYDbfHTJwVxdQIqc5X3hkqM8xGSlv07PTlZr6jdUAcfaDbyMt2H4iSyZDaLtbBJZ0=
X-Received: by 2002:a17:907:3e8d:b0:ab7:63fa:e49c with SMTP id
 a640c23a62f3a-ab789cbe110mr33651366b.36.1738875006155; Thu, 06 Feb 2025
 12:50:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250206191126.137262-1-slava@dubeyko.com>
In-Reply-To: <20250206191126.137262-1-slava@dubeyko.com>
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 6 Feb 2025 22:49:55 +0200
X-Gm-Features: AWEUYZmnW76Y5y4OkdtiQyLHG92zS6DklmFu7MdOwieBOCr6Eu4C9zlGMtJ3sRc
Message-ID: <CAO8a2Sjor8_Uu-uAm9JXR2MxQXuwy3nsddDkL6exj39W1PbBkg@mail.gmail.com>
Subject: Re: [PATCH] ceph: add process/thread ID into debug output
To: Viacheslav Dubeyko <slava@dubeyko.com>
Cc: ceph-devel@vger.kernel.org, idryomov@gmail.com, 
	linux-fsdevel@vger.kernel.org, pdonnell@redhat.com, Slava.Dubeyko@ibm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Alex Markuze <amarkuze@redhat.com>

On Thu, Feb 6, 2025 at 9:11=E2=80=AFPM Viacheslav Dubeyko <slava@dubeyko.co=
m> wrote:
>
> From: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
>
> Process/Thread ID (pid) is crucial and essential info
> during the debug and bug fix. It is really hard
> to analyze the debug output without these details.
> This patch addes PID info into the debug output.
>
> Signed-off-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
> ---
>  include/linux/ceph/ceph_debug.h | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/ceph/ceph_debug.h b/include/linux/ceph/ceph_de=
bug.h
> index 5f904591fa5f..6292db198f61 100644
> --- a/include/linux/ceph/ceph_debug.h
> +++ b/include/linux/ceph/ceph_debug.h
> @@ -16,13 +16,15 @@
>
>  # if defined(DEBUG) || defined(CONFIG_DYNAMIC_DEBUG)
>  #  define dout(fmt, ...)                                               \
> -       pr_debug("%.*s %12.12s:%-4d : " fmt,                            \
> +       pr_debug("pid %d %.*s %12.12s:%-4d : " fmt,                     \
> +                current->pid,                                          \
>                  8 - (int)sizeof(KBUILD_MODNAME), "    ",               \
>                  kbasename(__FILE__), __LINE__, ##__VA_ARGS__)
>  #  define doutc(client, fmt, ...)                                      \
> -       pr_debug("%.*s %12.12s:%-4d : [%pU %llu] " fmt,                 \
> +       pr_debug("pid %d %.*s %12.12s:%-4d %s() : [%pU %llu] " fmt,     \
> +                current->pid,                                          \
>                  8 - (int)sizeof(KBUILD_MODNAME), "    ",               \
> -                kbasename(__FILE__), __LINE__,                         \
> +                kbasename(__FILE__), __LINE__, __func__,               \
>                  &client->fsid, client->monc.auth->global_id,           \
>                  ##__VA_ARGS__)
>  # else
> --
> 2.48.0
>


