Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8CCA53FEAE
	for <lists+ceph-devel@lfdr.de>; Tue,  7 Jun 2022 14:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236018AbiFGMXh (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 08:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235998AbiFGMXf (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 08:23:35 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EFB0ABD2
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 05:23:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654604613;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7FOgk3ZKn6xA7vfKskjw+HEU0VyPzQrzljGbnYpZiVM=;
        b=NwiRo1K0Q5pFxWNI6pKiRcZciJwx1sGWJSXlE61IVwQhbmbxwTVf61G0p2Vsy7RpUAoSon
        QacHAUKg3fSll211vDwUJKotN5fiR22iiA6BBF8DOtrlqQmBmWwTtkYAYXV6fFZnl5vPeO
        X7xBt9yjTiKitXBjGQyjIejYcSCj4hM=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-543-q4-M8S-APT2T23UnGjHVVw-1; Tue, 07 Jun 2022 08:23:32 -0400
X-MC-Unique: q4-M8S-APT2T23UnGjHVVw-1
Received: by mail-pg1-f198.google.com with SMTP id f9-20020a636a09000000b003c61848e622so8589332pgc.0
        for <ceph-devel@vger.kernel.org>; Tue, 07 Jun 2022 05:23:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7FOgk3ZKn6xA7vfKskjw+HEU0VyPzQrzljGbnYpZiVM=;
        b=YZYt15ux7YdEj2OsGn8g2uFEf99DZP3+Ox6AtDbqawL0dQxp0RIK9zZVWfvNaZEWM6
         aLtZsyfoc7R0X8Onu42UmoYyHdjXRbT9++PpAnFZdroEXk3pR6TgnSzwV5jvUQWpz22b
         8b+j0E2GFn7D9VsyPSUlMWszikCP2Nr7Y7FrDYMxrgB08QHmrfv+xmH6eJxyypnaL6ry
         qNbajlvGGS9LcXmNdNAfKl5ldZthhtq8WnQLvN2KkHnRKNhNt3VoKUvK7j6yOxzMXhA1
         oa8sZP+TvOMAGsI6gNGddk8IUeUITmStB4Kkfj23Qgd67wnAikWDTp4jUDAAcj9J/Vxd
         EVXw==
X-Gm-Message-State: AOAM530WkpmyklKnzOEvfOL3dICuOU9eBDuzB2mIZ9VC+Oh1V7bAqAEX
        JNcz9jkr4GRSV+RmrRR3EPdOLVGGo1vdVkyO14RiuLxwC0m9CtsbFI9ZvDQeUrcOzwMO5RxMtse
        E/XF/xmVC7uxZtbvHX0W24EBFM4o9xtGoe0Ch4tnNXdheIyoaxdDkzmU5bJY96AEWpXucRqs=
X-Received: by 2002:a63:8a44:0:b0:3fc:a1f8:806d with SMTP id y65-20020a638a44000000b003fca1f8806dmr25810248pgd.363.1654604610279;
        Tue, 07 Jun 2022 05:23:30 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwiYZFzGo9ysQBIpNPkM5s+s8/dCl+4gbYC+b0iw4HFsWWcBjmpXYM4WQkJzvz5w39FeB5x4Q==
X-Received: by 2002:a63:8a44:0:b0:3fc:a1f8:806d with SMTP id y65-20020a638a44000000b003fca1f8806dmr25810221pgd.363.1654604609952;
        Tue, 07 Jun 2022 05:23:29 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id i13-20020a170902c94d00b0016362da9a03sm12425461pla.245.2022.06.07.05.23.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 05:23:29 -0700 (PDT)
Subject: Re: [PATCH] ceph: don't take inode lock in llseek
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
References: <20220607112712.18023-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <363c9909-5f62-82ec-2008-73689435c12d@redhat.com>
Date:   Tue, 7 Jun 2022 20:23:24 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220607112712.18023-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/7/22 7:27 PM, Jeff Layton wrote:
> There's no reason we need to lock the inode for write in order to handle
> an llseek. I suspect this should have been dropped in 2013 when we
> stopped doing vmtruncate in llseek.
>
> Fixes: b0d7c2231015 (ceph: introduce i_truncate_mutex)
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/file.c | 3 ---
>   1 file changed, 3 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 0c13a3f23c99..7d2e9615614d 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1994,8 +1994,6 @@ static loff_t ceph_llseek(struct file *file, loff_t offset, int whence)
>   	loff_t i_size;
>   	loff_t ret;
>   
> -	inode_lock(inode);
> -
>   	if (whence == SEEK_END || whence == SEEK_DATA || whence == SEEK_HOLE) {
>   		ret = ceph_do_getattr(inode, CEPH_STAT_CAP_SIZE, false);
>   		if (ret < 0)
> @@ -2038,7 +2036,6 @@ static loff_t ceph_llseek(struct file *file, loff_t offset, int whence)
>   	ret = vfs_setpos(file, offset, max(i_size, fsc->max_file_size));
>   
>   out:
> -	inode_unlock(inode);
>   	return ret;
>   }
>   

Looks good.

It seems the 'out' lable makes no sense anymore ?

-- Xiubo

