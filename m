Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7E933C5B68
	for <lists+ceph-devel@lfdr.de>; Mon, 12 Jul 2021 13:44:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235942AbhGLLVX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 12 Jul 2021 07:21:23 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:55017 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238333AbhGLLTs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 12 Jul 2021 07:19:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626088619;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=A8/QxthxbJRJRzBi6t5xgt4I/vM08rfliNXfZTNCGvA=;
        b=UDpm2ghd2hFlH81nTESIUx68qMjg+2qeXoADsUVshSRVeov6qDctB+Xlb5bCyx9H9+vjZb
        PPDEVmJvDASFHilzKOe1yVbi1cXX4zxzRHK5+2Wpn6Pc5s4HRjeooH/EPOKPnHtAN5dhmd
        4Kr1AUu/FKHmT2HsdxTgpKzTe0MoMWk=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-wpI4-tlzO3abDfALZft9dQ-1; Mon, 12 Jul 2021 07:16:57 -0400
X-MC-Unique: wpI4-tlzO3abDfALZft9dQ-1
Received: by mail-qt1-f197.google.com with SMTP id 61-20020aed21430000b029024e7e455d67so11026542qtc.16
        for <ceph-devel@vger.kernel.org>; Mon, 12 Jul 2021 04:16:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=A8/QxthxbJRJRzBi6t5xgt4I/vM08rfliNXfZTNCGvA=;
        b=ZPQHSItlfvcLc5abIOq8pkbQ7UZepnuyfbpBCKg/8ZZH34pGzCYttE5caenKtZg8AH
         gYV8aGjFBSaHerYBY0VYKP/D+4QiERFzxqmH8/5QkdV7CXCaplndouGGFX4Xh2cDkxWm
         IDWTwr4rQz4kq6MnS27vlYiDtTphHMOnlR655COTTJ+2d5jZe4mqGcqz2SiDLMs97YNM
         lVRcJLaFA6vtGnzT/0UaBynO9dtvARibdpFfucEGKGHItCD3CatrE4u2sVX3akPRAc+j
         JOBBaLhC4X0P+t5wrqxRiyqZCD4Z5f8oh+AJEcQUpEBIL0MdzusOps5NthEuo7CSq53e
         gANQ==
X-Gm-Message-State: AOAM530WyWhF+yoirnTXeDvURx4aF/QvPJ2as9jtMw6z+az5EXBnoV7K
        Emi7POyBgsoe06WVTsnUETP3R4ulacBUb5eH+sKmtU/Jd8RzKegssi3L4OVJM/3r/kpGMaStO5s
        l0bSqC6PMRP1v2CyRm4iQGw==
X-Received: by 2002:a0c:fc43:: with SMTP id w3mr51265596qvp.0.1626088617512;
        Mon, 12 Jul 2021 04:16:57 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxlSBHtSizAHwPN7sL60qPIS7/XswKZsE8DxZJpfS9VLwXN9GTP829cRimVO7l/hoBX/Pftsg==
X-Received: by 2002:a0c:fc43:: with SMTP id w3mr51265583qvp.0.1626088617387;
        Mon, 12 Jul 2021 04:16:57 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id v20sm5393950qto.89.2021.07.12.04.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jul 2021 04:16:56 -0700 (PDT)
Message-ID: <156ff0faf5324e7a17d14a021494a1d9cb0ecdce.camel@redhat.com>
Subject: Re: [PATCH v3 1/5] ceph: generalize addr/ip parsing based on
 delimiter
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, idryomov@gmail.com,
        lhenriques@suse.de
Cc:     pdonnell@redhat.com, ceph-devel@vger.kernel.org
Date:   Mon, 12 Jul 2021 07:16:56 -0400
In-Reply-To: <20210708084247.182953-2-vshankar@redhat.com>
References: <20210708084247.182953-1-vshankar@redhat.com>
         <20210708084247.182953-2-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, 2021-07-08 at 14:12 +0530, Venky Shankar wrote:
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  drivers/block/rbd.c            | 3 ++-
>  fs/ceph/super.c                | 3 ++-
>  include/linux/ceph/libceph.h   | 4 +++-
>  include/linux/ceph/messenger.h | 2 +-
>  net/ceph/ceph_common.c         | 8 ++++----
>  net/ceph/messenger.c           | 4 ++--
>  6 files changed, 14 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
> index bbb88eb009e0..209a7a128ea3 100644
> --- a/drivers/block/rbd.c
> +++ b/drivers/block/rbd.c
> @@ -6530,7 +6530,8 @@ static int rbd_add_parse_args(const char *buf,
>  	pctx.opts->exclusive = RBD_EXCLUSIVE_DEFAULT;
>  	pctx.opts->trim = RBD_TRIM_DEFAULT;
>  
> -	ret = ceph_parse_mon_ips(mon_addrs, mon_addrs_size, pctx.copts, NULL);
> +	ret = ceph_parse_mon_ips(mon_addrs, mon_addrs_size, pctx.copts, NULL,
> +				 CEPH_ADDR_PARSE_DEFAULT_DELIM);
>  	if (ret)
>  		goto out_err;
>  
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 9b1b7f4cfdd4..039775553a88 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -271,7 +271,8 @@ static int ceph_parse_source(struct fs_parameter *param, struct fs_context *fc)
>  		dout("server path '%s'\n", fsopt->server_path);
>  
>  	ret = ceph_parse_mon_ips(param->string, dev_name_end - dev_name,
> -				 pctx->copts, fc->log.log);
> +				 pctx->copts, fc->log.log,
> +				 CEPH_ADDR_PARSE_DEFAULT_DELIM);
>  	if (ret)
>  		return ret;
>  
> diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> index 409d8c29bc4f..e50dba429819 100644
> --- a/include/linux/ceph/libceph.h
> +++ b/include/linux/ceph/libceph.h
> @@ -98,6 +98,8 @@ struct ceph_options {
>  
>  #define CEPH_AUTH_NAME_DEFAULT   "guest"
>  
> +#define CEPH_ADDR_PARSE_DEFAULT_DELIM  ','
> +
>  /* mount state */
>  enum {
>  	CEPH_MOUNT_MOUNTING,
> @@ -301,7 +303,7 @@ struct fs_parameter;
>  struct fc_log;
>  struct ceph_options *ceph_alloc_options(void);
>  int ceph_parse_mon_ips(const char *buf, size_t len, struct ceph_options *opt,
> -		       struct fc_log *l);
> +		       struct fc_log *l, char delimiter);
>  int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
>  		     struct fc_log *l);
>  int ceph_print_client_options(struct seq_file *m, struct ceph_client *client,
> diff --git a/include/linux/ceph/messenger.h b/include/linux/ceph/messenger.h
> index 0e6e9ad3c3bf..c9675ee33f51 100644
> --- a/include/linux/ceph/messenger.h
> +++ b/include/linux/ceph/messenger.h
> @@ -532,7 +532,7 @@ extern const char *ceph_pr_addr(const struct ceph_entity_addr *addr);
>  
>  extern int ceph_parse_ips(const char *c, const char *end,
>  			  struct ceph_entity_addr *addr,
> -			  int max_count, int *count);
> +			  int max_count, int *count, char delimiter);
>  
>  extern int ceph_msgr_init(void);
>  extern void ceph_msgr_exit(void);
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index 97d6ea763e32..0f74ceeddf48 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -422,14 +422,14 @@ static int get_secret(struct ceph_crypto_key *dst, const char *name,
>  }
>  
>  int ceph_parse_mon_ips(const char *buf, size_t len, struct ceph_options *opt,
> -		       struct fc_log *l)
> +		       struct fc_log *l, char delimiter)
>  {
>  	struct p_log log = {.prefix = "libceph", .log = l};
>  	int ret;
>  
> -	/* ip1[:port1][,ip2[:port2]...] */
> +	/* ip1[:port1][<delim>ip2[:port2]...] */
>  	ret = ceph_parse_ips(buf, buf + len, opt->mon_addr, CEPH_MAX_MON,
> -			     &opt->num_mon);
> +			     &opt->num_mon, delimiter);
>  	if (ret) {
>  		error_plog(&log, "Failed to parse monitor IPs: %d", ret);
>  		return ret;
> @@ -456,7 +456,7 @@ int ceph_parse_param(struct fs_parameter *param, struct ceph_options *opt,
>  		err = ceph_parse_ips(param->string,
>  				     param->string + param->size,
>  				     &opt->my_addr,
> -				     1, NULL);
> +				     1, NULL, CEPH_ADDR_PARSE_DEFAULT_DELIM);
>  		if (err) {
>  			error_plog(&log, "Failed to parse ip: %d", err);
>  			return err;
> diff --git a/net/ceph/messenger.c b/net/ceph/messenger.c
> index 57d043b382ed..142fc70ea45d 100644
> --- a/net/ceph/messenger.c
> +++ b/net/ceph/messenger.c
> @@ -1267,7 +1267,7 @@ static int ceph_parse_server_name(const char *name, size_t namelen,
>   */
>  int ceph_parse_ips(const char *c, const char *end,
>  		   struct ceph_entity_addr *addr,
> -		   int max_count, int *count)
> +		   int max_count, int *count, char delimiter)
>  {
>  	int i, ret = -EINVAL;
>  	const char *p = c;
> @@ -1276,7 +1276,7 @@ int ceph_parse_ips(const char *c, const char *end,
>  	for (i = 0; i < max_count; i++) {
>  		const char *ipend;
>  		int port;
> -		char delim = ',';
> +		char delim = delimiter;
>  
>  		if (*p == '[') {
>  			delim = ']';

There is a place near the end of ceph_parse_ips:

                if (*p != ',')
                        goto bad;

I think that will also need to be changed to check against the delimiter
you passed in.
-- 
Jeff Layton <jlayton@redhat.com>

