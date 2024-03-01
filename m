Return-Path: <ceph-devel+bounces-942-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 60CD386D860
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Mar 2024 01:35:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5E0861C20EF9
	for <lists+ceph-devel@lfdr.de>; Fri,  1 Mar 2024 00:35:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA8423C5;
	Fri,  1 Mar 2024 00:35:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.b="p3XOsS5L"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EB92568
	for <ceph-devel@vger.kernel.org>; Fri,  1 Mar 2024 00:35:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709253348; cv=none; b=gkYxi+m+Jlz5Ah5Wal91dIAbkzq+sYytt2xMxUHF8TvGMl/iEbN323uWEhtZ8mqX71EygY6Q3Yv52iuCwcrCIDgxFvAo3n77vIxR0pD3e/3mIrdDY8fu94Bbo28DqvmHXWMKCZp2LuGY5BojIvn3AH9zyers3F1ZutP0ebYJxno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709253348; c=relaxed/simple;
	bh=QK09S2sQlJEZw4sA/tOf9ak1RVvkN27Q6uYXIdV/I1o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LLTh2oC1GADFwjZUmgVZJTWDZhTuvENprlZE3HG7ghlEnTa8ym7bU4kk/QmmcsX1e25FWF9hCGbCWC5vZqgXftXEyHwJUmTGcGm9VMwcglNkDJSYXYycdouz1w9hMGcVt/qPiMbddsX2XZQFrdL+z6unz8GG5F8riuTFsTZ5vqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name; spf=pass smtp.mailfrom=chrisdown.name; dkim=pass (1024-bit key) header.d=chrisdown.name header.i=@chrisdown.name header.b=p3XOsS5L; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-33e17fc5aceso360129f8f.0
        for <ceph-devel@vger.kernel.org>; Thu, 29 Feb 2024 16:35:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1709253346; x=1709858146; darn=vger.kernel.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QK09S2sQlJEZw4sA/tOf9ak1RVvkN27Q6uYXIdV/I1o=;
        b=p3XOsS5Lfa3ZVTuRFm1MxWAl1KFZnSgQSHTCXmSfNzjXZEOWvHQtygbRg2v8gdA9N2
         E1fjp+A+IHBWaEihZ/SKshPWjBPyhV4qzbLavWLOaT+aa2+UkmWdwLshcE7XvazF6pVD
         GDfobR7jP6bF9Min566uDlFM4xH21jNc8dr0M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709253346; x=1709858146;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QK09S2sQlJEZw4sA/tOf9ak1RVvkN27Q6uYXIdV/I1o=;
        b=rCVLSAz/+vxDLBo/Oha59DE6X9r3jAiUBT9EgQKY/pB+TfBTYn9cAphvHG91xX06/5
         NzrEc0noSwRqYsGLqmM/h06UOyWdnyKk/MGAkqFrDgItvD6EjVzsVMe2kgcnpdx+vrJH
         G1olkl6IC80x69AcAEhvLQPXx6NYKmobhEF3VEGB596tomSGxwXaD5T+1Q45OcYLKzPR
         zhFeRlpikVGGhxg96DST0VcxEmGLTgIg++AEH5CBdn8T9phDHbRLoel0CFifSqBnLN6o
         3Yig3yD2mNG19ZQ7hNjAkrcFyit3nV9CpyGNvn/VoXswzM8gVam05xwEwAxpMpNmVQh6
         AYUA==
X-Forwarded-Encrypted: i=1; AJvYcCUUC4mSPEN5dAv5nTbtCjAC0cYKNI/UmX88JXT2xnppoO7Yv5ff4P9y+ZRfqRMMsT2rdRONsRapRune8lqaSj1qDOO77iNMxO8kyA==
X-Gm-Message-State: AOJu0YyrEnmQkiorg6jVLRNWAcZF9hY1DOxqxMnPh8XaU8OBwYVoKpBf
	BA690C7ix9o8ukPRrQvo1TWfZ/CydKt4TXLG51vi+23an+EKYCAOs/kQKtYSmOI=
X-Google-Smtp-Source: AGHT+IEs3jQqAEI9fhp8IrVWdqsd9p5aKEl5FnIoeYTO8e2QwM3b2IqegwDgcnJ2DgoxInfDkD775w==
X-Received: by 2002:adf:9d89:0:b0:33d:eb13:9e27 with SMTP id p9-20020adf9d89000000b0033deb139e27mr80509wre.23.1709253345710;
        Thu, 29 Feb 2024 16:35:45 -0800 (PST)
Received: from localhost ([93.115.193.42])
        by smtp.gmail.com with ESMTPSA id f14-20020a5d50ce000000b0033b66c2d61esm3014534wrt.48.2024.02.29.16.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Feb 2024 16:35:45 -0800 (PST)
Date: Fri, 1 Mar 2024 00:35:44 +0000
From: Chris Down <chris@chrisdown.name>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Petr Mladek <pmladek@suse.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Jessica Yu <jeyu@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	John Ogness <john.ogness@linutronix.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jason Baron <jbaron@akamai.com>, Jim Cromie <jim.cromie@gmail.com>,
	Ilya Dryomov <idryomov@gmail.com>, Xiubo Li <xiubli@redhat.com>,
	Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org,
	ceph-devel@vger.kernel.org
Subject: Re: [PATCH 0/4] printk_index: Fix false positives
Message-ID: <ZeEi4IhVSh41cWYS@chrisdown.name>
References: <cover.1709127473.git.geert+renesas@glider.be>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <cover.1709127473.git.geert+renesas@glider.be>
User-Agent: Mutt/2.2.12 (2023-09-09)

Thanks for working on this! This whole patchset looks good to me.

Reviewed-by: Chris Down <chris@chrisdown.name>

