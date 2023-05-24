Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62CAD70EF21
	for <lists+ceph-devel@lfdr.de>; Wed, 24 May 2023 09:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240001AbjEXHMR (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 24 May 2023 03:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239674AbjEXHLt (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 24 May 2023 03:11:49 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FD1F10FF
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 00:09:26 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-96aae59bbd6so85189566b.3
        for <ceph-devel@vger.kernel.org>; Wed, 24 May 2023 00:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1684912157; x=1687504157;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MB0PkgtOYu2DAciIYbJ/doyhq3ZdSDKw62DeZCSSPtg=;
        b=FYCG0I0xG/KCzcPeRgfWGhFKBLQH8yo4Mb+b3h/3/MNGJYaOJxYFefWYzCbWzDOLJ5
         GslHMTl4heaZuqXTEmqMZYV3JWjK8Zt4w+vYkPylVmw2imfly3Tp8dcGkm97OVZ15gac
         hO02Kope0eh3dNS3sBBKR4sYeiW7mzVKy2JdY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684912157; x=1687504157;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MB0PkgtOYu2DAciIYbJ/doyhq3ZdSDKw62DeZCSSPtg=;
        b=fepHypmSlmyr/uN94YGfIWdZIg9BcJC1+QK+Geg8rdl9KDd4QxRCkkCcKEu8y4Q0t7
         /0xIiqB0fnlySAW2Ky0PCLsO1/qeI9oXOli+mnvNAngThfTB6nye3HmWOr8FEujW6BpS
         evclT1P93To7Ow894zSZYRgWT95MsnY1VCFFkXAcZun+fqhwKvXUIXv0av+X1VR3LWyL
         3GBAKuTE1HXyHzA71KKjNuAzBirqoVHSo9HzTwgac8dgaGLkSFxln05tm9WcAX8L+aHW
         jg4XBYXYNeN9TAYg4p1QTw5k92uwhl9nxHemqv3YRWELplvJodmrxsYvhOFXq3g4/7rZ
         lmWw==
X-Gm-Message-State: AC+VfDxQaPnNWG/P5kE9EvivmvaOju6x9DrOyLn1gVIwpr3ai7W+emGN
        cmWO7ltuB4H3rXS2RG0vC9V6Ep8dbkwK8uCjLQG1Wg==
X-Google-Smtp-Source: ACHHUZ4OvyrYEQkEUfZSmUZD5S0dixYDveppalH3smz8YjXbgWTLCqDqGb6U6n7MopqEkuxUiQE5XNBE/E81YW5lpSg=
X-Received: by 2002:a17:907:60cc:b0:96a:580e:bf0f with SMTP id
 hv12-20020a17090760cc00b0096a580ebf0fmr18686933ejc.14.1684912157630; Wed, 24
 May 2023 00:09:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230524063810.1595778-1-hch@lst.de> <20230524063810.1595778-12-hch@lst.de>
In-Reply-To: <20230524063810.1595778-12-hch@lst.de>
From:   Miklos Szeredi <miklos@szeredi.hu>
Date:   Wed, 24 May 2023 09:09:06 +0200
Message-ID: <CAJfpegtt2eD4Cw11f12cmcvHLe9VHhPLQdJWpwyAmeY-SrVuOA@mail.gmail.com>
Subject: Re: [PATCH 11/11] fuse: drop redundant arguments to fuse_perform_write
To:     Christoph Hellwig <hch@lst.de>
Cc:     Matthew Wilcox <willy@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Theodore Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>,
        Chao Yu <chao@kernel.org>,
        Andreas Gruenbacher <agruenba@redhat.com>,
        "Darrick J. Wong" <djwong@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna@kernel.org>,
        Damien Le Moal <dlemoal@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-block@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, cluster-devel@redhat.com,
        linux-xfs@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Wed, 24 May 2023 at 08:38, Christoph Hellwig <hch@lst.de> wrote:
>
> pos is always equal to iocb->ki_pos, and mapping is always equal to
> iocb->ki_filp->f_mapping.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

Acked-by: Miklos Szeredi <mszeredi@redhat.com>
