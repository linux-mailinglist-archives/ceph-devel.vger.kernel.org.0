Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C5B37BCA9E
	for <lists+ceph-devel@lfdr.de>; Sun,  8 Oct 2023 02:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344256AbjJHAWt (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Sat, 7 Oct 2023 20:22:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344227AbjJHAWs (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Sat, 7 Oct 2023 20:22:48 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3499FBC
        for <ceph-devel@vger.kernel.org>; Sat,  7 Oct 2023 17:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1696724519;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DbSfTUAEYDCU58vDmK84BW1S9S18QBjaTWpuTWyjJJ4=;
        b=KjHTUNi1Aq2/DkqiPBbBUQAiQVekPWC3yheLF/l/mf5+VOCg5AyjZpFZADw+LmtcpeMFzE
        1+xSlTKy4G9+VAW9G+8+F9eJq9y2HzZuBIhPOkrQ1lz0T5MiqPz84ybpcNv4LUzi9kyQGK
        5m0pKO0VsZ1SL0tQJ5pxMfMFrD0Vqk4=
Received: from mail-pl1-f200.google.com (mail-pl1-f200.google.com
 [209.85.214.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-98-QWwPr5DKOhm5HVmlJluqqA-1; Sat, 07 Oct 2023 20:21:52 -0400
X-MC-Unique: QWwPr5DKOhm5HVmlJluqqA-1
Received: by mail-pl1-f200.google.com with SMTP id d9443c01a7336-1c625d701b9so29987025ad.0
        for <ceph-devel@vger.kernel.org>; Sat, 07 Oct 2023 17:21:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696724511; x=1697329311;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DbSfTUAEYDCU58vDmK84BW1S9S18QBjaTWpuTWyjJJ4=;
        b=sOCcF1WGXXk/AR2QI4VN2NZShjC4Iua/vFcCf3z5Wezx9qXhd+XPRZ+rmec/iehTTP
         0L7VLa6YOu+twg70IYE4FNKlVTRrdt4sZk6PxgO3traITSfmY9ZGmvj+5tiWlamVw0Tf
         ZkJ+LScxNluygNjjuLcF54wVPt/R078lSe+CIUuAZ+f4qCoGMjXnUJsFXy1A4/t4FHNU
         x/sgf/iIskZe94Zr7HNgdAvegZORCkBtKqFfekxqe2fbYBW1QPz2yI3bRyHDNQH6J573
         Iw4iojFkXbxKaq/3iQxokbXMz5r5q/ZzsHv3104sw0B+v9jHSBYhfYlDBCm/AfgIXtU/
         7zeg==
X-Gm-Message-State: AOJu0YyzJEKGzB3ESBLkrE5Bl/RXax1PvCcozvc3SBEIjPHhkIyDikHy
        Ya/zwt6bpgiOLFdYIrk6aXrPyyUvmbqikA/Pg8s6Dv9cPvE7V8utGZxxyYF7z0SUrJLg8vlEfQJ
        /sNFVF6bMebUtDPcIogoOVN4a0JrSiw==
X-Received: by 2002:a17:902:bf0c:b0:1bc:3944:9391 with SMTP id bi12-20020a170902bf0c00b001bc39449391mr9818207plb.25.1696724511698;
        Sat, 07 Oct 2023 17:21:51 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFNGTmBIqGaiEfqliWefpMvSkpkJYgmXVVhgSkUzxFdxhaevcRlDDFL5Hy5rLo6WWtkAs2Kpg==
X-Received: by 2002:a17:902:bf0c:b0:1bc:3944:9391 with SMTP id bi12-20020a170902bf0c00b001bc39449391mr9818201plb.25.1696724511363;
        Sat, 07 Oct 2023 17:21:51 -0700 (PDT)
Received: from [10.72.112.95] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id jf2-20020a170903268200b001c736370245sm6502391plb.54.2023.10.07.17.21.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Oct 2023 17:21:50 -0700 (PDT)
Message-ID: <a86080f4-3a40-8ae2-9bc5-9859298b7cbb@redhat.com>
Date:   Sun, 8 Oct 2023 08:21:45 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ceph: fix type promotion bug on 32bit systems
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@linaro.org>,
        Luis Henriques <lhenriques@suse.com>
Cc:     Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
References: <5e0418d3-a31b-4231-80bf-99adca6bcbe5@moroto.mountain>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <5e0418d3-a31b-4231-80bf-99adca6bcbe5@moroto.mountain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 10/7/23 16:52, Dan Carpenter wrote:
> In this code "ret" is type long and "src_objlen" is unsigned int.  The
> problem is that on 32bit systems, when we do the comparison signed longs
> are type promoted to unsigned int.  So negative error codes from
> do_splice_direct() are treated as success instead of failure.
>
> Fixes: 1b0c3b9f91f0 ("ceph: re-org copy_file_range and fix some error paths")
> Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
> ---
> 32bit is so weird and ancient.  It's strange to think that unsigned int
> has more positive bits than signed long.
>
>   fs/ceph/file.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index b1da02f5dbe3..b5f8038065d7 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -2969,7 +2969,7 @@ static ssize_t __ceph_copy_file_range(struct file *src_file, loff_t src_off,
>   		ret = do_splice_direct(src_file, &src_off, dst_file,
>   				       &dst_off, src_objlen, flags);
>   		/* Abort on short copies or on error */
> -		if (ret < src_objlen) {
> +		if (ret < (long)src_objlen) {
>   			dout("Failed partial copy (%zd)\n", ret);
>   			goto out;
>   		}

Good catch and makes sense to me.

I also ran a test in 64bit system, the output is the same too:

int x = -1
unsigned int y = 2
x > y

Reviewed-by: Xiubo Li <xiubli@redhat.com>

Thanks

- Xiubo

