Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 093D443352B
	for <lists+ceph-devel@lfdr.de>; Tue, 19 Oct 2021 13:54:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235356AbhJSL4y (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 19 Oct 2021 07:56:54 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25621 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235206AbhJSL4x (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 19 Oct 2021 07:56:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1634644476;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=l1RY98ACwgzQ/sShaeOro3ifhVp3abGLehnvJ93Aim4=;
        b=JgsSHKTJtlTzaNh1kkC2flcS4BRRJQ1tlKNXSwpIP5/RPHgUIXwxG1v437gvo0lOBFiXLC
        udcE/99f1uLwUKsW/UEQfRIshARrjyiGmhMdi9qVvREdoQvUiGZI+70J/zgg+7Qn0hBH7H
        KjyZkc1IZcBORLi5/IrGYuYMp+KgOlU=
Received: from mail-pf1-f199.google.com (mail-pf1-f199.google.com
 [209.85.210.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-248-AEo1_zP3ONyTvIe2uANM4g-1; Tue, 19 Oct 2021 07:54:35 -0400
X-MC-Unique: AEo1_zP3ONyTvIe2uANM4g-1
Received: by mail-pf1-f199.google.com with SMTP id q3-20020aa79823000000b0044d24283b63so10909141pfl.5
        for <ceph-devel@vger.kernel.org>; Tue, 19 Oct 2021 04:54:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=l1RY98ACwgzQ/sShaeOro3ifhVp3abGLehnvJ93Aim4=;
        b=tBLud6/XMFjdoAPpRq1YkaZ7NPqtsDUf/MrTv8KbbxMi2s4CkJORDz11h4l24OCvUG
         45c/ybYgqWFVmaxT5ctTYTb1hypyu5LvuHiyBdzVJ3yLA0C9vdkPngQlTkPDHOUSl08s
         T3MCSFNpVVwLcoAvotkWTFpPpD7Oy7+Qg8OJgj/qaHNLHKcn8SyWLt+gh1Unsb/n5HTa
         Chnu5DKTq/zYe8d09gzH6GPX8/3ghalRD8c79ZIlVi8EZdPBs5VOUk53H+LtT000oHjF
         nk4jEdAIdOrTYt1voVz6VIl3oywHXjstNYeYM60ILBOR59YwVRmG8K576jQQrquuMvAh
         rVPQ==
X-Gm-Message-State: AOAM531SM6JYHySTS576Thg3yVVqw4V4nhB+c5UIZpyB9w1LFgCaqGaR
        4EM/jIQl+CMjnH3gDfHF2mE9owKdESYDE6Mq0lwOljKUZE1q7cAB+tCSOwPzQHYfYJMwKujmPwQ
        JRDu+NVMjFSWRp5++dOevcsmEtMwqC/K79u2q8fUueoTS3JGrvxsBU41gM/AdTUUcQyb3Jyc=
X-Received: by 2002:a17:90a:17e1:: with SMTP id q88mr6041833pja.99.1634644473167;
        Tue, 19 Oct 2021 04:54:33 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyBBcDR0Un9GVweS1vZFXcQbstj3rEW+Fz9rM029z4nD2dkmlT3w0ri7XC0ilZZ/H4niWuzmA==
X-Received: by 2002:a17:90a:17e1:: with SMTP id q88mr6041792pja.99.1634644472751;
        Tue, 19 Oct 2021 04:54:32 -0700 (PDT)
Received: from [10.72.12.135] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q14sm5302666pfk.3.2021.10.19.04.54.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Oct 2021 04:54:32 -0700 (PDT)
Subject: Re: [PATCH] ceph: return the real size readed when hit EOF
To:     jlayton@kernel.org
Cc:     idryomov@gmail.com, khiremat@redhat.com, pdonnell@redhat.com,
        ceph-devel@vger.kernel.org
References: <20211019115138.414187-1-xiubli@redhat.com>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <04eda2a9-29aa-1157-e9f5-b655a4e06b9d@redhat.com>
Date:   Tue, 19 Oct 2021 19:54:26 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211019115138.414187-1-xiubli@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Without this, such as in case for the file encrypt feature, when doing 
the following test:

1), echo "1234567890" > dir/a.txt

2), vim dir/a.txt

It will always show the zeroed contents after string "1234567890", 
something like:

"1234567890@@@@@...."

On 10/19/21 7:51 PM, xiubli@redhat.com wrote:
> From: Xiubo Li <xiubli@redhat.com>
>
> At the same time set the ki_pos to the file size.
>
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>   fs/ceph/file.c | 14 +++++++++-----
>   1 file changed, 9 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 91173d3aa161..1abc3b591740 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -847,6 +847,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>   	ssize_t ret;
>   	u64 off = iocb->ki_pos;
>   	u64 len = iov_iter_count(to);
> +	u64 i_size = i_size_read(inode);
>   
>   	dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
>   	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");
> @@ -870,7 +871,6 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>   		struct page **pages;
>   		int num_pages;
>   		size_t page_off;
> -		u64 i_size;
>   		bool more;
>   		int idx;
>   		size_t left;
> @@ -909,7 +909,6 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>   
>   		ceph_osdc_put_request(req);
>   
> -		i_size = i_size_read(inode);
>   		dout("sync_read %llu~%llu got %zd i_size %llu%s\n",
>   		     off, len, ret, i_size, (more ? " MORE" : ""));
>   
> @@ -954,10 +953,15 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>   
>   	if (off > iocb->ki_pos) {
>   		if (ret >= 0 &&
> -		    iov_iter_count(to) > 0 && off >= i_size_read(inode))
> +		    iov_iter_count(to) > 0 &&
> +		    off >= i_size_read(inode)) {
>   			*retry_op = CHECK_EOF;
> -		ret = off - iocb->ki_pos;
> -		iocb->ki_pos = off;
> +			ret = i_size - iocb->ki_pos;
> +			iocb->ki_pos = i_size;
> +		} else {
> +			ret = off - iocb->ki_pos;
> +			iocb->ki_pos = off;
> +		}
>   	}
>   
>   	dout("sync_read result %zd retry_op %d\n", ret, *retry_op);

