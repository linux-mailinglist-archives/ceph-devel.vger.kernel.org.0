Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66EE345A2D8
	for <lists+ceph-devel@lfdr.de>; Tue, 23 Nov 2021 13:40:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236864AbhKWMnH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 23 Nov 2021 07:43:07 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:45843 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237029AbhKWMnH (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Tue, 23 Nov 2021 07:43:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637671198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dupgwZpNogZYoXPYKTSlyfdra30UeZ7jaevbUJX6+24=;
        b=TqNHKMw7tRKN+z1bG3sFpjwejZHlohboveTfHG4Gx+dMIKdAMip1Dx1s0LsSTtht2KhR8L
        /Vq0BAf/+Xzw2wHgSK9xVUk8QWs4HRhT4DNEYH9nTRVI4s1CnafWvlN6sVoTJ45onvB4Ux
        DYayqUrh+RMivymLI4bbZI5d3v98f5k=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-560-l1tCZ1kEPg6goZuqUwKLgQ-1; Tue, 23 Nov 2021 07:39:57 -0500
X-MC-Unique: l1tCZ1kEPg6goZuqUwKLgQ-1
Received: by mail-pl1-f198.google.com with SMTP id y6-20020a17090322c600b001428ab3f888so8903465plg.8
        for <ceph-devel@vger.kernel.org>; Tue, 23 Nov 2021 04:39:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=dupgwZpNogZYoXPYKTSlyfdra30UeZ7jaevbUJX6+24=;
        b=8LduAYecT3j8dAuQC2I2LJPqD9efPOT2yYaE4Yoju6LSYjOzNz9tIEKWURiihnpPEU
         ii84kJnhNv//gbCo6VkCbXdHREhboxEUvMV1NJYMlHgnSkS+l96mgML1x6QvfDwAum6b
         r4JWEJnItxgb5Zd5lpdCF0Aw1aAypVg0Nl82dydV8N0np8mY1rEy0TBFNZqaK4D4HGgh
         LBHgOsvUA7N16MOLgrEYSXksQNGu21+gUaFHVXO5n5loOrdIx+WiJhBalW1kvdVGNLvy
         0YWqT84mIILnJA6aebZAeqofjpYdv1zIqbH4PJd4hBRKI/wF/28KGgIuVvO6Casq3w5d
         fAYg==
X-Gm-Message-State: AOAM5313L8YIfrFzdpjVN68zMlJhdXe6pXxy6PlEcNFR6kgJM5rlH4ar
        NIwTv9WROAWhUlx5zQ/pYR8z7dwADGpQWzM2tGsBL2IJa2bvsmLEBX3IFXo5OjIBJW+xWAr4cGk
        Z/Q8IV5TqF7Kl9IQGQFT0C8dfH2roLLDmMB2TVG1t5or1oQbB0h2bywx/3p1AYGomhCd9u3g=
X-Received: by 2002:a63:1d13:: with SMTP id d19mr3516765pgd.383.1637671195979;
        Tue, 23 Nov 2021 04:39:55 -0800 (PST)
X-Google-Smtp-Source: ABdhPJycUmet0mmrE7hQhIR4LX+yyMMw5ueVvjKQtva9FeyE/mJRbuvw2O25FlOp+CQ5yTYrW3G0AQ==
X-Received: by 2002:a63:1d13:: with SMTP id d19mr3516728pgd.383.1637671195527;
        Tue, 23 Nov 2021 04:39:55 -0800 (PST)
Received: from [10.72.12.80] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id w19sm1226339pjh.10.2021.11.23.04.39.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 04:39:52 -0800 (PST)
Subject: Re: [PATCH] ceph: initialize i_size variable in ceph_sync_read
To:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <20211123123439.70644-1-jlayton@kernel.org>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <9e30bb77-7840-2588-a860-829b29f178b2@redhat.com>
Date:   Tue, 23 Nov 2021 20:39:45 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20211123123439.70644-1-jlayton@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 11/23/21 8:34 PM, Jeff Layton wrote:
> Newer compilers seem to determine that this variable being uninitialized
> isn't a problem, but older compilers (from the RHEL8 era) seem to choke
> on it and complain that it could be used uninitialized.
>
> Go ahead and initialize the variable at declaration time to silence
> potential compiler warnings.
>
> Fixes: c3d8e0b5de48 ("ceph: return the real size read when it hits EOF")
> Cc: Xiubo Li <xiubli@redhat.com>
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>   fs/ceph/file.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index 220a41831b46..69ea42392f51 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -847,7 +847,7 @@ static ssize_t ceph_sync_read(struct kiocb *iocb, struct iov_iter *to,
>   	ssize_t ret;
>   	u64 off = iocb->ki_pos;
>   	u64 len = iov_iter_count(to);
> -	u64 i_size;
> +	u64 i_size = i_size_read(inode);
>   
>   	dout("sync_read on file %p %llu~%u %s\n", file, off, (unsigned)len,
>   	     (file->f_flags & O_DIRECT) ? "O_DIRECT" : "");

LGTM.

Reviewed-by: Xiubo Li <xiubli@redhat.com>

