Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8720B3B647E
	for <lists+ceph-devel@lfdr.de>; Mon, 28 Jun 2021 17:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236076AbhF1PIy (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 28 Jun 2021 11:08:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59579 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235329AbhF1PGv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Mon, 28 Jun 2021 11:06:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1624892665;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=78XMMyVNOtvYPjTj2bI34imeyvb08Lxmpw5pB+YFi5E=;
        b=deSv4KqlxE697VB2uuoS1DZ7hCtebBsxo8sBlx+ix/tN8JRcuc6kw8x2Dj6htTjh23zM+h
        nNu/LUbhxmnSUiXiQYfY2g3RfyxgjILHxbK/+2vAF8kGeVQG9YE9J0nizRF/uVy0PzvKBN
        UohkFWpDTX9FZsYM3r1ba60aBox6phQ=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-538-f5dQsWueMDS6ln3hzpPgXA-1; Mon, 28 Jun 2021 11:04:23 -0400
X-MC-Unique: f5dQsWueMDS6ln3hzpPgXA-1
Received: by mail-qk1-f197.google.com with SMTP id c17-20020a37e1110000b02903b3a029f1f2so4019464qkm.12
        for <ceph-devel@vger.kernel.org>; Mon, 28 Jun 2021 08:04:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=78XMMyVNOtvYPjTj2bI34imeyvb08Lxmpw5pB+YFi5E=;
        b=qulak6nFrQGS08Ga5zeK1RaV0Q36c8ikWG0sxzJ5HRRtWWUDqlnv6t2FxaD4SJ57tN
         6IcdFu0cYwxNOm2qKiXVA3WtWebgzZ+CN6rAVUmOfqdHfdAc4buYWhq/PJVHAFL87XL2
         bGaaSHJcozQ3VxFkp87yKn70QujSII3s4uF8DqXlsyMb7cgQidUTPIzk4Gevwnn6OK3R
         k+QT0dGVC5nQkdPbnSUGl9oj6Yn+JGm6w1a3SyOSGGaEMrA39XGM2i6KsvZa8gxocZ1Z
         7xSIUKVow4v4ciIWDabvkV63JMGWlCU7k13hTacEat4g1QnY0wc/sUXSNXnGNdTFghsE
         7wMA==
X-Gm-Message-State: AOAM532zNymVbfDp6NeZ9bnGuf6iaxpXPBLDXJdSUbNnmcCRrh3BHTm1
        LDhwkoPgk/qCVPr+1WTbejNHSNnRkLvsPOwAbl4G6oFKDqxaU6SBIpMNHOiPt5TaUFJYgrBLsO/
        m45YrLr/FERxT1ziEE2Qsjw==
X-Received: by 2002:a05:622a:1991:: with SMTP id u17mr19174073qtc.18.1624892663015;
        Mon, 28 Jun 2021 08:04:23 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxNYJ2JmeTunmeNa/1HtoSweMzveh65lexFjm/q3Q97Q3cTuFP1N0OsKJ/Yvg9Lnfb9qT7sqA==
X-Received: by 2002:a05:622a:1991:: with SMTP id u17mr19174048qtc.18.1624892662812;
        Mon, 28 Jun 2021 08:04:22 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id y8sm4162607qtw.43.2021.06.28.08.04.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Jun 2021 08:04:22 -0700 (PDT)
Message-ID: <77c1bc3093a7f74c92a1deb35c0e80291c4d9b52.camel@redhat.com>
Subject: Re: [PATCH 2/4] ceph: validate cluster FSID for new device syntax
From:   Jeff Layton <jlayton@redhat.com>
To:     Venky Shankar <vshankar@redhat.com>, idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
Date:   Mon, 28 Jun 2021 11:04:21 -0400
In-Reply-To: <20210628075545.702106-3-vshankar@redhat.com>
References: <20210628075545.702106-1-vshankar@redhat.com>
         <20210628075545.702106-3-vshankar@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, 2021-06-28 at 13:25 +0530, Venky Shankar wrote:
> The new device syntax requires the cluster FSID as part
> of the device string. Use this FSID to verify if it matches
> the cluster FSID we get back from the monitor, failing the
> mount on mismatch.
> 
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>  fs/ceph/super.c              | 9 +++++++++
>  fs/ceph/super.h              | 1 +
>  include/linux/ceph/libceph.h | 1 +
>  net/ceph/ceph_common.c       | 3 ++-
>  4 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 950a28ad9c59..84bc06e51680 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -266,6 +266,9 @@ static int ceph_parse_new_source(const char *dev_name, const char *dev_name_end,
>  	if (!fs_name_start)
>  		return invalfc(fc, "missing file system name");
>  
> +	if (parse_fsid(fsid_start, &fsopt->fsid))
> +		return invalfc(fc, "invalid fsid format");
> +
>  	++fs_name_start; /* start of file system name */
>  	fsopt->mds_namespace = kstrndup(fs_name_start,
>  					dev_name_end - fs_name_start, GFP_KERNEL);
> @@ -748,6 +751,12 @@ static struct ceph_fs_client *create_fs_client(struct ceph_mount_options *fsopt,
>  	}
>  	opt = NULL; /* fsc->client now owns this */
>  
> +	/* help learn fsid */
> +	if (fsopt->new_dev_syntax) {
> +		ceph_check_fsid(fsc->client, &fsopt->fsid);
> +		fsc->client->have_fsid = true;
> +	}
> +
>  	fsc->client->extra_mon_dispatch = extra_mon_dispatch;
>  	ceph_set_opt(fsc->client, ABORT_ON_FULL);
>  
> diff --git a/fs/ceph/super.h b/fs/ceph/super.h
> index 557348ff3203..cfd8ec25a9a8 100644
> --- a/fs/ceph/super.h
> +++ b/fs/ceph/super.h
> @@ -100,6 +100,7 @@ struct ceph_mount_options {
>  	char *server_path;    /* default NULL (means "/") */
>  	char *fscache_uniq;   /* default NULL */
>  	char *mon_addr;
> +	struct ceph_fsid fsid;
>  };
>  
>  struct ceph_fs_client {
> diff --git a/include/linux/ceph/libceph.h b/include/linux/ceph/libceph.h
> index 409d8c29bc4f..24c1f4e9144d 100644
> --- a/include/linux/ceph/libceph.h
> +++ b/include/linux/ceph/libceph.h
> @@ -296,6 +296,7 @@ extern bool libceph_compatible(void *data);
>  extern const char *ceph_msg_type_name(int type);
>  extern int ceph_check_fsid(struct ceph_client *client, struct ceph_fsid *fsid);
>  extern void *ceph_kvmalloc(size_t size, gfp_t flags);
> +extern int parse_fsid(const char *str, struct ceph_fsid *fsid);
>  
>  struct fs_parameter;
>  struct fc_log;
> diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
> index 97d6ea763e32..db21734462a4 100644
> --- a/net/ceph/ceph_common.c
> +++ b/net/ceph/ceph_common.c
> @@ -217,7 +217,7 @@ void *ceph_kvmalloc(size_t size, gfp_t flags)
>  	return p;
>  }
>  
> -static int parse_fsid(const char *str, struct ceph_fsid *fsid)
> +int parse_fsid(const char *str, struct ceph_fsid *fsid)
>  {
>  	int i = 0;
>  	char tmp[3];
> @@ -247,6 +247,7 @@ static int parse_fsid(const char *str, struct ceph_fsid *fsid)
>  	dout("parse_fsid ret %d got fsid %pU\n", err, fsid);
>  	return err;
>  }
> +EXPORT_SYMBOL(parse_fsid);

This function name is too generic. Maybe rename it to "ceph_parse_fsid"?

>  
>  /*
>   * ceph options

-- 
Jeff Layton <jlayton@redhat.com>

