Return-Path: <ceph-devel+bounces-3988-lists+ceph-devel=lfdr.de@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1AE0DC4AA9D
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Nov 2025 02:36:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0AB163B1CAB
	for <lists+ceph-devel@lfdr.de>; Tue, 11 Nov 2025 01:26:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46226304BD5;
	Tue, 11 Nov 2025 01:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=minyard-net.20230601.gappssmtp.com header.i=@minyard-net.20230601.gappssmtp.com header.b="1X0bIYLP"
X-Original-To: ceph-devel@vger.kernel.org
Received: from mail-oa1-f65.google.com (mail-oa1-f65.google.com [209.85.160.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 014E23064AB
	for <ceph-devel@vger.kernel.org>; Tue, 11 Nov 2025 01:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823866; cv=none; b=LHlSwzYWZceGpfzG/8x3dAfNiW2jQieK9UZmFN7WndnQZWSYaQM37eTOGi6KMK2GTLYG9J0nu6r/xl+xJcT7QvPP3cukSIlI/SGHytM6pk2vT4Fri4R/zpiuaDYawrZSiYXb3NARFEpHvQE7U6KRhsGvSjs8ewy7rJTtf0UisfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823866; c=relaxed/simple;
	bh=/awKTS4VkDV7YyuY2XqMrgn1/FWXuaIp1CGhvSR3qsg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YI6l9m1sDbedQg3nGWIUOR9bvWk4YRBA/9e/wn8nbsd0IvN3Ctz8tsrfgv5GFi+1Uo0tj3EzGh7iE65JXDOjoSktDn6V/dBstUa6RggUesCNUmhU4nNI15i+psa5kWqubnRYXXYtgYL/64WhQUXXeWoWCFgKbeCVD4/E5bEA/wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=minyard.net; spf=none smtp.mailfrom=minyard.net; dkim=pass (2048-bit key) header.d=minyard-net.20230601.gappssmtp.com header.i=@minyard-net.20230601.gappssmtp.com header.b=1X0bIYLP; arc=none smtp.client-ip=209.85.160.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=minyard.net
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=minyard.net
Received: by mail-oa1-f65.google.com with SMTP id 586e51a60fabf-3e7f68df436so207957fac.1
        for <ceph-devel@vger.kernel.org>; Mon, 10 Nov 2025 17:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=minyard-net.20230601.gappssmtp.com; s=20230601; t=1762823863; x=1763428663; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IjPKo3ybe4fdml1XQE+jQ3G55BcDMlVXlR9cl8yZWH4=;
        b=1X0bIYLPg5FTcJXhMNg4pxmUb76wfaApB+l+loii0/FgtqX/HWlaE6aNarA3fA9Js9
         Cwr/pnjVw/q3j5GgfUcYJJmUxw/jTInjI6MeuuAxCyfd67UbKjFyQTJeeL68hCUtpCgv
         FiR1iNbtgqjlwBPrj2nm0cbbtIsbIvO0nK++V7ByOhJx2aJAFWsu3V+P7WutbzH2gkaJ
         CBY9dbIIANg6ZmHz/nZ3ngHXtPb7Hj43JsC/t5rIl7DR3aQwyV19mNxAMyhHyzknHFLy
         qjd9pzDGh7fMH3dh49XFDtb87Ae4NleYzlXTxHYnKhEGBfrmvt+33yPlDBX1ApO1D4i7
         ip+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762823863; x=1763428663;
        h=in-reply-to:content-disposition:mime-version:references:reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IjPKo3ybe4fdml1XQE+jQ3G55BcDMlVXlR9cl8yZWH4=;
        b=Zo92cfFMO5r2ZO+BDphgkotnZdGsHj8Ca4888qryNxi0BGP0r8q+o1ynyPoXZzOliA
         77u2IAktS6/BEFA25iTs0WVM5oFWl7c7HVt9fNzbeUih3f7koXFfEfhgvBP4SBYTRjtZ
         Qx6BU8MSPq52tiWqQEj1XAwPAwCPZwqT2PQqX0m+IAgyLjA4nqo7qBo0zxwIbDHj+UXx
         eBUpF6IzsvcSgKcPlEQcsHvta6qNZWIxVk5+iFnSAQgwqKvpo/zIdJ1dQdhSxck7IjvX
         1rPQ9AwYGlzTr57OuSr6F3tPoSrnNwa8AaYroogQDcqlcSV6kwBddO+TenpmTsFDIVOe
         aaxA==
X-Forwarded-Encrypted: i=1; AJvYcCVAfXL4CaVDxrjG0qgSQbOyYv4CbwINdtFBIgFNHzljnFpfV1G/N97T+zmEWOgVtsjSPOAslwhaqaDE@vger.kernel.org
X-Gm-Message-State: AOJu0YzBXZhc+bOutq1kxDqiluq7pNZ6JG/4Ir+8OBJNkIrjH5peOVzp
	/qn03F+Hg2sme7BQ7vijogF+77JmcoH5hdWIWljepzE/9b9n7cIbTsyWNgLQOu9S7Lg=
X-Gm-Gg: ASbGnctoXoLq16crvgsoE3oE95ttjwj3z0rW1ufeh0Jmy3Z7+gTMuyQs6WfUZXyzyQf
	IKH8s3swhr26xOpurZQCrq4ht2j24ch2mJtp5ShUryMhruSPzIYiYpPlZ3/WFj57h2pbbRxeRrX
	rEFtW8lEAnRggimATqz4bkfaV28CwfOGMqdYUH3aopcRAjleqDW9tfb5a7Sid7iPY6OUV8smlwZ
	sdSn2XX07vfJNieHUBtBnx6Q8WJ61XXGRs3/oa0br0Ct6o3hWsiblCd4VNqTYJojlYEzw40Ob9C
	0X9LVy+Zn7OgVWCdk+fYi3U4CbQnJ5RiCNQA7Csx/T71lpnD2x9NQZPIA+BRiMfBb/eUF+BnAfN
	cFba0c05DSW5zRf1eiT7Gox6TmOVDOVm8/Y0L91DuXmP0Ko9hZ2CidNwgDdAQQxHVM0B5GsfBVW
	bEYoAT0EUnaA0+gg==
X-Google-Smtp-Source: AGHT+IHYqlJ/DqUior2uObKb688W9mKskJnwhdBfDC1sLOPoqWKjn2HRpxRv5pN7HFxTPVj3Axvofg==
X-Received: by 2002:a05:6870:46a8:b0:3e1:d34:4283 with SMTP id 586e51a60fabf-3e815aaa2a3mr850172fac.19.1762823862970;
        Mon, 10 Nov 2025 17:17:42 -0800 (PST)
Received: from mail.minyard.net ([2001:470:b8f6:1b:b4e9:19a3:cdaf:7174])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-3e7d6f7a27dsm4076840fac.0.2025.11.10.17.17.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 17:17:41 -0800 (PST)
Date: Mon, 10 Nov 2025 19:17:35 -0600
From: Corey Minyard <corey@minyard.net>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Christian K??nig <christian.koenig@amd.com>,
	"Dr. David Alan Gilbert" <linux@treblig.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Hans Verkuil <hverkuil@kernel.org>,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Vitaly Lifshits <vitaly.lifshits@intel.com>,
	Manivannan Sadhasivam <mani@kernel.org>,
	Niklas Cassel <cassel@kernel.org>, Calvin Owens <calvin@wbinvd.org>,
	Sagi Maimon <maimon.sagi@gmail.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Karan Tilak Kumar <kartilak@cisco.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Petr Mladek <pmladek@suse.com>,
	Max Kellermann <max.kellermann@ionos.com>,
	Takashi Iwai <tiwai@suse.de>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	openipmi-developer@lists.sourceforge.net,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org, amd-gfx@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, linux-mmc@vger.kernel.org,
	netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
	linux-pci@vger.kernel.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org, linux-staging@lists.linux.dev,
	ceph-devel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
	linux-sound@vger.kernel.org,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Gustavo Padovan <gustavo@padovan.org>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Abhinav Kumar <abhinav.kumar@linux.dev>,
	Jessica Zhang <jesszhan0024@gmail.com>, Sean Paul <sean@poorly.run>,
	Marijn Suijten <marijn.suijten@somainline.org>,
	Konrad Dybcio <konradybcio@kernel.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>,
	Thomas Hellstr??m <thomas.hellstrom@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Vladimir Oltean <olteanv@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Przemek Kitszel <przemyslaw.kitszel@intel.com>,
	Krzysztof Wilczy??ski <kwilczynski@kernel.org>,
	Kishon Vijay Abraham I <kishon@kernel.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Jonathan Lemon <jonathan.lemon@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Richard Cochran <richardcochran@gmail.com>,
	Stefan Haberland <sth@linux.ibm.com>,
	Jan Hoeppner <hoeppner@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Satish Kharat <satishkh@cisco.com>,
	Sesidhar Baddela <sebaddel@cisco.com>,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>
Subject: Re: [PATCH v1 12/23] ipmi: Switch to use %ptSp
Message-ID: <aRKOr2hyoqTnh85-@mail.minyard.net>
Reply-To: corey@minyard.net
References: <20251110184727.666591-1-andriy.shevchenko@linux.intel.com>
 <20251110184727.666591-13-andriy.shevchenko@linux.intel.com>
Precedence: bulk
X-Mailing-List: ceph-devel@vger.kernel.org
List-Id: <ceph-devel.vger.kernel.org>
List-Subscribe: <mailto:ceph-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:ceph-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251110184727.666591-13-andriy.shevchenko@linux.intel.com>

On Mon, Nov 10, 2025 at 07:40:31PM +0100, Andy Shevchenko wrote:
> Use %ptSp instead of open coded variants to print content of
> struct timespec64 in human readable format.
> 
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

Quite a bit neater, yes.

Acked-by: Corey Minyard <cminyard@mvista.com>

> ---
>  drivers/char/ipmi/ipmi_si_intf.c | 3 +--
>  drivers/char/ipmi/ipmi_ssif.c    | 6 ++----
>  2 files changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
> index 70e55f5ff85e..5459ffdde8dc 100644
> --- a/drivers/char/ipmi/ipmi_si_intf.c
> +++ b/drivers/char/ipmi/ipmi_si_intf.c
> @@ -275,8 +275,7 @@ void debug_timestamp(struct smi_info *smi_info, char *msg)
>  	struct timespec64 t;
>  
>  	ktime_get_ts64(&t);
> -	dev_dbg(smi_info->io.dev, "**%s: %lld.%9.9ld\n",
> -		msg, t.tv_sec, t.tv_nsec);
> +	dev_dbg(smi_info->io.dev, "**%s: %ptSp\n", msg, &t);
>  }
>  #else
>  #define debug_timestamp(smi_info, x)
> diff --git a/drivers/char/ipmi/ipmi_ssif.c b/drivers/char/ipmi/ipmi_ssif.c
> index 1b63f7d2fcda..ef1582a029f4 100644
> --- a/drivers/char/ipmi/ipmi_ssif.c
> +++ b/drivers/char/ipmi/ipmi_ssif.c
> @@ -1083,10 +1083,8 @@ static int sender(void *send_info, struct ipmi_smi_msg *msg)
>  		struct timespec64 t;
>  
>  		ktime_get_real_ts64(&t);
> -		dev_dbg(&ssif_info->client->dev,
> -			"**Enqueue %02x %02x: %lld.%6.6ld\n",
> -			msg->data[0], msg->data[1],
> -			(long long)t.tv_sec, (long)t.tv_nsec / NSEC_PER_USEC);
> +		dev_dbg(&ssif_info->client->dev, "**Enqueue %02x %02x: %ptSp\n",
> +			msg->data[0], msg->data[1], &t);
>  	}
>  	return IPMI_CC_NO_ERROR;
>  }
> -- 
> 2.50.1
> 

