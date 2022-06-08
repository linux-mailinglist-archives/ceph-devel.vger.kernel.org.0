Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79A235426DF
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jun 2022 08:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231152AbiFHDn2 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 7 Jun 2022 23:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231790AbiFHDnJ (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 7 Jun 2022 23:43:09 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E936322B796
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 17:53:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654649603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=VWhZ705uZddb5FJJZyASJYc7s+JPiuENCs1dD7YM9/E=;
        b=QpYPlbdxfFJM0xIVaeN1shNbF+n4HJkEy/ID94o1Cb8LSILcSrSCQOGiY2YV+qtZVEVcvO
        IHZfiXkcruFZ5rsnewINCQADUXmNFe00i3OdtfNoQsQYf8RWMhSckXcFuUK6Dr2eCAgHIU
        lXy2EnvWW7O/3F3noMItZtumjlTQvEk=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-96-UZSJb0qrNk-Tsl-lpI7N3A-1; Tue, 07 Jun 2022 20:53:21 -0400
X-MC-Unique: UZSJb0qrNk-Tsl-lpI7N3A-1
Received: by mail-pl1-f198.google.com with SMTP id x1-20020a170902ec8100b0016634ff72a4so9293189plg.15
        for <ceph-devel@vger.kernel.org>; Tue, 07 Jun 2022 17:53:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=VWhZ705uZddb5FJJZyASJYc7s+JPiuENCs1dD7YM9/E=;
        b=eT1XtFAluYd+0Dqe+mF/ed40IkqLvbeEbCgHkMmvc06BQ1ml49eMx3peGAINDy0uft
         75C99T1cSBZFk5QFMhGfj+2/B73FfbQ16ZIOrx5pgfXUJFwJcIaVMvLB4MUCZYE7js2V
         DJN+7go8zJJKNnbWL1lWCu/oQ55xSJlV6vMpNsGgM27p6MSmB5McEtohkYl6ryicGqIJ
         zvX2bJ6Szs1SwWduGX7EyndXhy3wg7HVzPwPQdaMe1gE164V01eInm84AT3czCfOtGEO
         JoCvl9ZAC2aq4yH2T8Qrlieieh/nHrr9W34SB0thPdRy9aJwOx02K6CvI+VTWSjReYi4
         8MaA==
X-Gm-Message-State: AOAM533XGVHq4oBCtKcDACZqwPznRT5MTiOdAzjFfIXXyG8dUlsQxuwr
        33euFH8BdJeCPLdlQcsn+uFZKV6dYIn4CZ8FwIOgd/bnwlAes4mEF++6XkjcrIB2G8v9bHS/FL0
        cp2uzvTQuR9ob8edYJgne5pAXg8TwIEY/4rPqzKyaprQgdpk0fuEJmark1fJmq0GA30O2FqY=
X-Received: by 2002:a05:6a00:814:b0:51c:1878:4943 with SMTP id m20-20020a056a00081400b0051c18784943mr13582159pfk.62.1654649599656;
        Tue, 07 Jun 2022 17:53:19 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXzUbmFxRhmomGtQQmfZrRxPdPx2tR9siHzJA9+YPIQactWWsc8LiEaFRZKu8coyzVpo3FkA==
X-Received: by 2002:a05:6a00:814:b0:51c:1878:4943 with SMTP id m20-20020a056a00081400b0051c18784943mr13582137pfk.62.1654649599300;
        Tue, 07 Jun 2022 17:53:19 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id d2-20020a17090abf8200b001e305f5cd22sm12525875pjs.47.2022.06.07.17.53.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 17:53:18 -0700 (PDT)
Subject: Re: [PATCH] ceph: convert to generic_file_llseek
To:     Jeff Layton <jlayton@kernel.org>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org
References: <20220607150549.217390-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <f9e51ae1-501a-a6cc-4331-30d4d204bbd4@redhat.com>
Date:   Wed, 8 Jun 2022 08:53:12 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220607150549.217390-1-jlayton@kernel.org>
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


On 6/7/22 11:05 PM, Jeff Layton wrote:
> There's no reason we need to lock the inode for write in order to handle
> an llseek. I suspect this should have been dropped in 2013 when we
> stopped doing vmtruncate in llseek.
>
> With that gone, ceph_llseek is functionally equivalent to
> generic_file_llseek, so just call that after getting the size.
>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/file.c | 52 +++++---------------------------------------------
>   1 file changed, 5 insertions(+), 47 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 0c13a3f23c99..0e82a1c383ca 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1989,57 +1989,15 @@ static ssize_t ceph_write_iter(struct kiocb *iocb, struct iov_iter *from)
>    */
>   static loff_t ceph_llseek(struct file *file, loff_t offset, int whence)
>   {
> -	struct inode *inode = file->f_mapping->host;
> -	struct ceph_fs_client *fsc = ceph_inode_to_client(inode);
> -	loff_t i_size;
> -	loff_t ret;
> -
> -	inode_lock(inode);
> -
>   	if (whence == SEEK_END || whence == SEEK_DATA || whence == SEEK_HOLE) {
> +		struct inode *inode = file_inode(file);
> +		int ret;
> +
>   		ret = ceph_do_getattr(inode, CEPH_STAT_CAP_SIZE, false);
>   		if (ret < 0)
> -			goto out;
> -	}
> -
> -	i_size = i_size_read(inode);
> -	switch (whence) {
> -	case SEEK_END:
> -		offset += i_size;
> -		break;
> -	case SEEK_CUR:
> -		/*
> -		 * Here we special-case the lseek(fd, 0, SEEK_CUR)
> -		 * position-querying operation.  Avoid rewriting the "same"
> -		 * f_pos value back to the file because a concurrent read(),
> -		 * write() or lseek() might have altered it
> -		 */
> -		if (offset == 0) {
> -			ret = file->f_pos;
> -			goto out;
> -		}
> -		offset += file->f_pos;
> -		break;
> -	case SEEK_DATA:
> -		if (offset < 0 || offset >= i_size) {
> -			ret = -ENXIO;
> -			goto out;
> -		}
> -		break;
> -	case SEEK_HOLE:
> -		if (offset < 0 || offset >= i_size) {
> -			ret = -ENXIO;
> -			goto out;
> -		}
> -		offset = i_size;
> -		break;
> +			return ret;
>   	}
> -
> -	ret = vfs_setpos(file, offset, max(i_size, fsc->max_file_size));
> -
> -out:
> -	inode_unlock(inode);
> -	return ret;
> +	return generic_file_llseek(file, offset, whence);
>   }
>   
>   static inline void ceph_zero_partial_page(

LGTM. Merged into the testing branch. Thanks Jeff.

-- Xiubo

