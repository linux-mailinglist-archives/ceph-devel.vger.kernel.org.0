Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 028B53B6597
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Jun 2021 17:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237166AbhF1PbD (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Jun 2021 11:31:03 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:56108 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238274AbhF1P3a (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 28 Jun 2021 11:29:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624894023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3rdPp0pk7+QSHPKJnTWcCH3WKZcvgwhEv+9ihwSAHZg=;
        b=fzsPIAhQyXWD0B5unBMW1f1/dlysCJq08g1fbeaumKFwS3cE2iri20BcOivV5HekcK9Oqo
        gj+TCr7uc2V4B3l5mXUtziSBJd27A0GM3kwwLHBhkMQTpQj+lE95tZ9emHrkUhR6CbIKsF
        yFA830+NtrHXdNrylueuNXv46qJd7dw=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-70--1dXuZEoPtqpM5REM8XW_A-1; Mon, 28 Jun 2021 11:27:01 -0400
X-MC-Unique: -1dXuZEoPtqpM5REM8XW_A-1
Received: by mail-qt1-f198.google.com with SMTP id d7-20020ac811870000b02901e65f85117bso13009965qtj.18
        for <ceph-devel@vger.kernel.org>; Mon, 28 Jun 2021 08:27:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=3rdPp0pk7+QSHPKJnTWcCH3WKZcvgwhEv+9ihwSAHZg=;
        b=cV0AZeWB6KzravHoOBzCxCHEJM2483voXcA29r/UraKZuz/WpqxvXNWz3THSmK53qN
         YAvF7J0dgB/mYQXYuyjlL5TZJqINc0B5VuebrNY/CZbFUJfZlRcYBJXhGsZjEMsjAM9I
         vTU2PW+jSXbXq/HZagPOwnrjwuR4qFonSXNrLlOdPl/pz1LJpxXvL1QS5YNHpqcqwnKF
         MnC0wxV3Re27ZZx18qTaJa/vfHHq80jyHgIpcYMDB7jyuKzs/Y1V4GVf3WzBi/ZOTxxj
         /b+/LIZKTJvRzufimHzCS8tpht3BcJ7HjxwH3fHl2BYbEsZlxueR5zyMEvUZnUQ/hIp7
         OkSg==
X-Gm-Message-State: AOAM5322HdBFvmFIPlscY1Ind3ic56ubaAiRRh4TS9ZFxWdbF+AnmfVm
        ZqlxLgeYGekAOlsOA6w/iGc5prJ07dbI64RDfeGKVIrxAXxH7bdzjOVKML8AcVqMgf5ItTd7nNd
        sNR0oNCWzN0nHqEMEDDt4Vw==
X-Received: by 2002:ad4:54f2:: with SMTP id k18mr26181620qvx.32.1624894021186;
        Mon, 28 Jun 2021 08:27:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz8CAUoJLpuiw3ESMOHoNJS0j5InVtwD3yiTCGAfVZPzZkkmQVVcPchTQid6u3zUGwN/IvonQ==
X-Received: by 2002:ad4:54f2:: with SMTP id k18mr26181609qvx.32.1624894021041;
        Mon, 28 Jun 2021 08:27:01 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id t139sm10199613qka.85.2021.06.28.08.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 08:27:00 -0700 (PDT)
Message-ID: <efacd6bfc864c5a29291e8ab24f82e0a6bd9022e.camel@redhat.com>
Subject: Re: [PATCH 4/4] doc: document new CephFS mount device syntax
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
Date:   Mon, 28 Jun 2021 11:26:59 -0400
In-Reply-To: <20210628075545.702106-5-vshankar@redhat.com>
References: <20210628075545.702106-1-vshankar@redhat.com>
         <20210628075545.702106-5-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-06-28 at 13:25 +0530, Venky Shankar wrote:
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  Documentation/filesystems/ceph.rst | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/Documentation/filesystems/ceph.rst b/Documentation/filesystems/ceph.rst
> index 7d2ef4e27273..e46f9091b851 100644
> --- a/Documentation/filesystems/ceph.rst
> +++ b/Documentation/filesystems/ceph.rst
> @@ -82,7 +82,7 @@ Mount Syntax
>  
>  The basic mount syntax is::
>  
> - # mount -t ceph monip[:port][,monip2[:port]...]:/[subdir] mnt
> + # mount -t ceph user@fsid.fs_name=/[subdir] mnt -o mon_host=monip1[:port][/monip2[:port]]
>  

The actual code lists the option as "mon_addr".

>  You only need to specify a single monitor, as the client will get the
>  full list when it connects.  (However, if the monitor you specify
> @@ -90,16 +90,33 @@ happens to be down, the mount won't succeed.)  The port can be left
>  off if the monitor is using the default.  So if the monitor is at
>  1.2.3.4::
>  
> - # mount -t ceph 1.2.3.4:/ /mnt/ceph
> + # mount -t ceph cephuser@07fe3187-00d9-42a3-814b-72a4d5e7d5be.cephfs=/ /mnt/ceph -o mon_host=1.2.3.4
>  
>  is sufficient.  If /sbin/mount.ceph is installed, a hostname can be
> -used instead of an IP address.
> +used instead of an IP address and the cluster FSID can be left out
> +(as the mount helper will fill it in by reading the ceph configuration
> +file)::
>  
> +  # mount -t ceph cephuser@cephfs=/ /mnt/ceph -o mon_host=mon-addr
>  
> +Multiple monitor addresses can be passed by separating each address with a slash (`/`)::
> +
> +  # mount -t ceph cephuser@cephfs=/ /mnt/ceph -o mon_host=192.168.1.100/192.168.1.101
> +
> +When using the mount helper, monitor address can be read from ceph
> +configuration file if available. Note that, the cluster FSID (passed as part
> +of the device string) is validated by checking it with the FSID reported by
> +the monitor.
>  
>  Mount Options
>  =============
>  
> +  mon_host=ip_address[:port][/ip_address[:port]]
> +	Monitor address to the cluster
> +

Might want to mention that "mon_addr" is just used to bootstrap the
connection to the cluster, and that it'll follow the monmap after that
point.

> +  fsid=cluster-id
> +	FSID of the cluster
> +
>    ip=A.B.C.D[:N]
>  	Specify the IP and/or port the client should bind to locally.
>  	There is normally not much reason to do this.  If the IP is not

-- 
Jeff Layton <jlayton@redhat.com>

