Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DF8552EC43
	for <lists+ceph-devel@lfdr.de>; Fri, 20 May 2022 14:38:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346652AbiETMh6 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 20 May 2022 08:37:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231533AbiETMh5 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 20 May 2022 08:37:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id B762DEC3FD
        for <ceph-devel@vger.kernel.org>; Fri, 20 May 2022 05:37:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1653050275;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9whQyY1EYjeR+0iDqwxkYYJEYaXtQv6rKB1zeo3PNgo=;
        b=J+v6XaYCn/35XEdaM0nVmpZPVNipr672Hw4BN2+GE4CBw0WJd5t0hf591QQmrpPHQs1Ip5
        up5RQ6r+YbFcukspI98PaNI1DR/P+iyW4uwsRBctPvqGEYarAg625eX1Ux22/7H28g540w
        KpRDwnq44KLRIB1CGqVh73nj9kbhiWc=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-QA9BrCqJOdagQXUNyZXC7g-1; Fri, 20 May 2022 08:37:54 -0400
X-MC-Unique: QA9BrCqJOdagQXUNyZXC7g-1
Received: by mail-qt1-f200.google.com with SMTP id c4-20020ac85a84000000b002f923018222so396808qtc.16
        for <ceph-devel@vger.kernel.org>; Fri, 20 May 2022 05:37:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=9whQyY1EYjeR+0iDqwxkYYJEYaXtQv6rKB1zeo3PNgo=;
        b=iun7qo+AcVN7allgknz7HUdsYFXA/Rt/TPVY0DE8THDI7/i+bUZJBlPzkoiqe0W5IW
         u56/XSoWCBVSZbfnlkxPWvaRhF9BhSDdd4HzQSDu1iz6YDHfYu9gq58qKHr+PgtiqzzY
         vV6igLmxFzmga0Ky9SnO7BrVkigU9yAnUluGCQPtc+52uBjGtimIbLbFjDekBUig1bSa
         KBs1uL1tMuXz+MjKLBzlSfBRL2CwT4nJefG5jj/qlbsK9q0US33UMacCgZ3T0vBje6A/
         l0XTCSqDWHyHs5hhpvtuw1qt/TS/bF4kxsw/yh0hV8agNJ0LYjfG6zwItHcdTA5+FUwe
         51uA==
X-Gm-Message-State: AOAM533H3jz+MrQ+6dPePqgMvUse8+2EBW9t4Us3eaJyfdNJRsr2PeQh
        xULZehvdRi6PZ0n/SAsrgMKgF4B5JigYiBeR9nEB8mKVO4E+PO2zORbCpJ2uaV9RvS6FjxEr8aC
        4/dYcZ5TCByaM1W3idyJJrw==
X-Received: by 2002:a05:620a:1790:b0:6a0:65dc:4dbf with SMTP id ay16-20020a05620a179000b006a065dc4dbfmr6027788qkb.545.1653050273837;
        Fri, 20 May 2022 05:37:53 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwNe/bkOsGPImCs8XbrSOfvEFml+KSCpE2Fxf+3DrNSpOSaYiiCDK86J583xH+4N/kkHIjXNA==
X-Received: by 2002:a05:620a:1790:b0:6a0:65dc:4dbf with SMTP id ay16-20020a05620a179000b006a065dc4dbfmr6027776qkb.545.1653050273562;
        Fri, 20 May 2022 05:37:53 -0700 (PDT)
Received: from zlang-mailbox ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id q28-20020a37f71c000000b0069fc13ce1d4sm3192964qkj.5.2022.05.20.05.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 May 2022 05:37:52 -0700 (PDT)
Date:   Fri, 20 May 2022 20:37:47 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     =?utf-8?B?THXDrXM=?= Henriques <lhenriques@suse.de>
Cc:     fstests@vger.kernel.org, ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph/002: fix test expected output
Message-ID: <20220520123747.cbpeg6ox7orxmiqp@zlang-mailbox>
References: <20220520094709.30365-1-lhenriques@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220520094709.30365-1-lhenriques@suse.de>
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Fri, May 20, 2022 at 10:47:09AM +0100, Luís Henriques wrote:
> Commit daa0c0146c7d ("fstests: replace hexdump with od command") broke
> ceph/002 by adding an extra '0' in the offset column.  Fix it.
> 
> Signed-off-by: Luís Henriques <lhenriques@suse.de>
> ---

Oh, that's my bad, I changed that in daa0c014 ("fstests: replace hexdump
with od command"), but write an extra '0' for ceph/002.out [1]. And due to
I don't test cephfs, so missed this failure. Thanks for fixing it!

Reviewed-by: Zorro Lang <zlang@redhat.com>

[1]
...
diff --git a/tests/ceph/002.out b/tests/ceph/002.out
index 6f067250..f7f1c0ba 100644
--- a/tests/ceph/002.out
+++ b/tests/ceph/002.out
@@ -1,8 +1,8 @@
 QA output created by 002
-0000000 6161 6161 6161 6161 6161 6161 6161 6161
+000000 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61 61  >aaaaaaaaaaaaaaaa<
 *
-0400000 6262 6262 6262 6262 6262 6262 6262 6262
+400000 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62 62  >bbbbbbbbbbbbbbbb<
 *
-0800000 6363 6363 6363 6363 6363 6363 6363 6363
+800000 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63  >cccccccccccccccc<
 *
-0c00000
+c000000
...

>  tests/ceph/002.out | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tests/ceph/002.out b/tests/ceph/002.out
> index f7f1c0ba8487..4f766c257a9c 100644
> --- a/tests/ceph/002.out
> +++ b/tests/ceph/002.out
> @@ -5,4 +5,4 @@ QA output created by 002
>  *
>  800000 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63 63  >cccccccccccccccc<
>  *
> -c000000
> +c00000
> 

