Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF17C5426CA
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jun 2022 08:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbiFHEwX (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jun 2022 00:52:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231524AbiFHEvx (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jun 2022 00:51:53 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 676C7253FC1
        for <ceph-devel@vger.kernel.org>; Tue,  7 Jun 2022 18:17:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654651049;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=slIHfG8WZ1tWaqj1MJ5t7kKpXqQTszZtJPACqYjHZNA=;
        b=YGBbc9TrCx9jlv+J3kQtAWJyiWIt2oyMYrWr02au9G+ATRpK7Uo8rDIR59XJkixBD2wSay
        9p9G8iZnkztsOhNfmVpsnitFsKuVKLgj/6GAEf+CwolDSme8egfSfT8yx0bUiretS3pUxO
        36yTPsS52zptCMmMaMOgTev82mJf59U=
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com
 [209.85.210.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-86-w0i-UORdORm48htU1s427A-1; Tue, 07 Jun 2022 21:17:28 -0400
X-MC-Unique: w0i-UORdORm48htU1s427A-1
Received: by mail-pf1-f200.google.com with SMTP id d2-20020aa78142000000b0051c394e5226so1984025pfn.19
        for <ceph-devel@vger.kernel.org>; Tue, 07 Jun 2022 18:17:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=slIHfG8WZ1tWaqj1MJ5t7kKpXqQTszZtJPACqYjHZNA=;
        b=mAYXXp20lZvwy3OMAFmWCh7hAcRrG6zrM94bH87RlKNo4VGIwxy0pDaC9F66jcbsyp
         HHPZ8Zn7eLZCWiGVeq+HSTp+wrZwzR/H6tRnGTpyx1Z3lBeeLRZ99snivo1OJ92wkfZ1
         OVTn9Bdr47HAYBhXTIdQstah9XWb1gjJDq+Wtnvz0byBvfucp8AS2i8r9hZX30R/Qzsm
         FB3zjLI/Nl8R02xrvzda9Aa61U59xdmGRGe6n5KMNOqBmy74fizaOmsZaqruCzsAAV0J
         UNsKeGyjhFP+BKqnhsx+6lMzWKpQG0n/MP561LlsXU9CdGpEXWHfHlG5MhVGrkKtCinW
         uexw==
X-Gm-Message-State: AOAM530uClEOTO2p6vGVU/oA5O0YLRBlrKrPJsmW812ZGXpEaRu3v/KL
        SVnlId0VX2tGrI2QQ/vF1frlT+4VxByxsk428pg2nq5MmUjaV1taSbvnDe5AkLsTEk7dbiWZUn0
        f3AZaq6MNUjJoFerRDHbQmTu6mpA28q62NeenGxOJaf/XGfP8vntbIcCHVT//qbua0oUjIq8=
X-Received: by 2002:a17:90b:3789:b0:1e3:459a:1202 with SMTP id mz9-20020a17090b378900b001e3459a1202mr35055607pjb.113.1654651046791;
        Tue, 07 Jun 2022 18:17:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJy91FkFQWS5eg/s4cNvErfR3p00QGMIw4CuWJEyPUjL7TOYQ/5xvNgJaY6GfHMtGvmhjQa74g==
X-Received: by 2002:a17:90b:3789:b0:1e3:459a:1202 with SMTP id mz9-20020a17090b378900b001e3459a1202mr35055586pjb.113.1654651046496;
        Tue, 07 Jun 2022 18:17:26 -0700 (PDT)
Received: from [10.72.12.54] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id kw3-20020a17090b220300b001e2f6c7b6f6sm12597863pjb.10.2022.06.07.18.17.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jun 2022 18:17:25 -0700 (PDT)
Subject: Re: [PATCH v2] src/attr_replace_test: dynamically adjust the max
 xattr size
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        fstests@vger.kernel.org, "Darrick J. Wong" <djwong@kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
References: <87wnds8mxv.fsf@brahms.olymp>
 <20220607165153.27797-1-lhenriques@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
Message-ID: <9c21300a-e731-443f-39a0-38da3204c975@redhat.com>
Date:   Wed, 8 Jun 2022 09:17:19 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220607165153.27797-1-lhenriques@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


On 6/8/22 12:51 AM, Luís Henriques wrote:
> CephFS doesn't had a maximum xattr size.  Instead, it imposes a maximum size
> for the full set of xattrs names+values, which by default is 64K but may be
> changed.
>
> Test generic/486 started to fail after fixing a ceph bug where this limit
> wasn't being imposed.  Adjust dynamically the size of the xattr being set
> if the error returned is -ENOSPC.
>
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---
>   src/attr_replace_test.c | 5 ++++-
>   1 file changed, 4 insertions(+), 1 deletion(-)
>
> diff --git a/src/attr_replace_test.c b/src/attr_replace_test.c
> index cca8dcf8ff60..d1b92703ba2a 100644
> --- a/src/attr_replace_test.c
> +++ b/src/attr_replace_test.c
> @@ -62,7 +62,10 @@ int main(int argc, char *argv[])
>   
>   	/* Then, replace it with bigger one, forcing short form to leaf conversion. */
>   	memset(value, '1', size);
> -	ret = fsetxattr(fd, name, value, size, XATTR_REPLACE);
> +	do {
> +		ret = fsetxattr(fd, name, value, size, XATTR_REPLACE);
> +		size -= 256;

I am not sure whether will this break other filesystems tests.

Maybe we should get the filesystem type first from 'st_mode', and then 
in ceph case we should minus strlen(name) before replacing the it. And 
then if it fails with '-ENOSPC' do the following ?

Or maybe we could get maximum length of xattr from ioctl(fd) in ceph case ?


> +	} while ((ret < 0) && (errno == ENOSPC) && (size > 256));
>   	if (ret < 0) die();
>   	close(fd);
>   
>

