Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61DA64D5DFF
	for <lists+ceph-devel@lfdr.de>; Fri, 11 Mar 2022 09:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243929AbiCKJAj (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 11 Mar 2022 04:00:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243794AbiCKJAe (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 11 Mar 2022 04:00:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C99661BB721
        for <ceph-devel@vger.kernel.org>; Fri, 11 Mar 2022 00:59:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646989170;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=h1N2UA4IRcQ5yuritNYyqad7YdVxQSw6/fgBt3P2aNk=;
        b=hlHvhLCdzfbN+iCVgdpZxDHrkgUh5T9O9S6Mt7oNYQzGAnSZggz3201YXxlymETn7zwr7T
        s5SFMvegR8Dka9jReR2qihVeB3xoW1VnuFAISNbuqVjb6ZKYmc1Fjyf0CMHkWn2xiO6oVR
        wxk+5snsmArjkoUs+sut41MutnL/Cdw=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-627-iZDku8nXOC6nuiUNpSCt7Q-1; Fri, 11 Mar 2022 03:59:29 -0500
X-MC-Unique: iZDku8nXOC6nuiUNpSCt7Q-1
Received: by mail-pg1-f199.google.com with SMTP id 196-20020a6307cd000000b0038027886594so4498334pgh.4
        for <ceph-devel@vger.kernel.org>; Fri, 11 Mar 2022 00:59:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=h1N2UA4IRcQ5yuritNYyqad7YdVxQSw6/fgBt3P2aNk=;
        b=aOdNQm7t4QSpJUA1TggL7gBAeU6ok2rceyEz+J2S/TKBEh7up/I8Ak5E2OPeFq00oA
         Y9pJNfR8LcsV0EGt8ncom04JgZbAaqVESVx3dJ71mNDDwZz6L7fgKkK5udrnVku5tGom
         TiFF5fNBRboDNmbSfyECtZvzol9uptxUWVHEYFsc68rwXkFeFPlR4FX677h2IiEgBdvj
         JP90q5P1EkhOignRliBCPjvjRPThSQlI6wMR6Z9a84H0aPGP6AFZOcXhqcDO38rklPyK
         09zpC/gi3wKWVxn1JN5N9hPYXEA5pbd2Q2ql8kGXkRu+CjsEp0u18dqLJfeZlJutNUx5
         QDgQ==
X-Gm-Message-State: AOAM533MyYClsNlQckHUITzPK8rE+JGI7hSfd8NDeYUzqxgDOVm4p1aH
        P0snREldFuL4lmwXCg2GFz8bW8Qb2wDbYyBMsRAX4RwbsiHHXlsgfmXEHS5rlW4J0x6WZH7dfjF
        ALwKLY0rG2LpSz72qbTNZU7bsxKyyQhrbW55nEovwZQ3zKoIGdM63S66MayOHsmwHZqX/nl4=
X-Received: by 2002:a05:6a00:174b:b0:4f7:8e44:6fdb with SMTP id j11-20020a056a00174b00b004f78e446fdbmr1421261pfc.64.1646989168017;
        Fri, 11 Mar 2022 00:59:28 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzOXvXZakD9Ac30l/7OiEiF9StPOako0AaiCIg3M/RunQJ4GJCMUQ/kaSdj4mq6HK8Wi762MQ==
X-Received: by 2002:a05:6a00:174b:b0:4f7:8e44:6fdb with SMTP id j11-20020a056a00174b00b004f78e446fdbmr1421234pfc.64.1646989167638;
        Fri, 11 Mar 2022 00:59:27 -0800 (PST)
Received: from [10.72.12.132] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id y20-20020aa78054000000b004f6f267dcc9sm9289474pfm.187.2022.03.11.00.59.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Mar 2022 00:59:26 -0800 (PST)
Subject: Re: [PATCH] ceph: allow `ceph.dir.rctime' xattr to be updatable
To:     Venky Shankar <vshankar@redhat.com>, jlayton@redhat.com,
        idryomov@gmail.com
Cc:     ceph-devel@vger.kernel.org
References: <20220310143419.14284-1-vshankar@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <844eb610-54d1-5bcd-bc8c-5e4d1f898f21@redhat.com>
Date:   Fri, 11 Mar 2022 16:59:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220310143419.14284-1-vshankar@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 3/10/22 10:34 PM, Venky Shankar wrote:
> `rctime' has been a pain point in cephfs due to its buggy
> nature - inconsistent values reported and those sorts.
> Fixing rctime is non-trivial needing an overall redesign
> of the entire nested statistics infrastructure.
>
> As a workaround, PR
>
>       http://github.com/ceph/ceph/pull/37938
>
> allows this extended attribute to be manually set. This allows
> users to "fixup" inconsistency rctime values. While this sounds
> messy, its probably the wisest approach allowing users/scripts
> to workaround buggy rctime values.
>
> The above PR enables Ceph MDS to allow manually setting
> rctime extended attribute with the corresponding user-land
> changes. We may as well allow the same to be done via kclient
> for parity.
>
> Signed-off-by: Venky Shankar <vshankar@redhat.com>
> ---
>   fs/ceph/xattr.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
>
> diff --git a/fs/ceph/xattr.c b/fs/ceph/xattr.c
> index afec84088471..8c2dc2c762a4 100644
> --- a/fs/ceph/xattr.c
> +++ b/fs/ceph/xattr.c
> @@ -366,6 +366,14 @@ static ssize_t ceph_vxattrcb_auth_mds(struct ceph_inode_info *ci,
>   	}
>   #define XATTR_RSTAT_FIELD(_type, _name)			\
>   	XATTR_NAME_CEPH(_type, _name, VXATTR_FLAG_RSTAT)
> +#define XATTR_RSTAT_FIELD_UPDATABLE(_type, _name)			\
> +	{								\
> +		.name = CEPH_XATTR_NAME(_type, _name),			\
> +		.name_size = sizeof (CEPH_XATTR_NAME(_type, _name)),	\
> +		.getxattr_cb = ceph_vxattrcb_ ## _type ## _ ## _name,	\
> +		.exists_cb = NULL,					\
> +		.flags = VXATTR_FLAG_RSTAT,				\
> +	}
>   #define XATTR_LAYOUT_FIELD(_type, _name, _field)			\
>   	{								\
>   		.name = CEPH_XATTR_NAME2(_type, _name, _field),	\
> @@ -404,7 +412,7 @@ static struct ceph_vxattr ceph_dir_vxattrs[] = {
>   	XATTR_RSTAT_FIELD(dir, rsubdirs),
>   	XATTR_RSTAT_FIELD(dir, rsnaps),
>   	XATTR_RSTAT_FIELD(dir, rbytes),
> -	XATTR_RSTAT_FIELD(dir, rctime),
> +	XATTR_RSTAT_FIELD_UPDATABLE(dir, rctime),
>   	{
>   		.name = "ceph.dir.pin",
>   		.name_size = sizeof("ceph.dir.pin"),

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


