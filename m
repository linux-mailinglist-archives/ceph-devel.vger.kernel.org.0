Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0587C72DCC8
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 10:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238425AbjFMIkT (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 04:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241722AbjFMIj4 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 04:39:56 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 547441BEC
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 01:39:48 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id 4fb4d7f45d1cf-5186c90e3bbso1558180a12.3
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 01:39:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686645586; x=1689237586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I75s87zKIQdrkEMYwa6WVWiel4x5Y1zYxgEy0yTGKmQ=;
        b=gnxC0y3ajDjSkPTs3X7G54zfgUqpWjX87rMkRAVPnCPYHS+A/Vcw7onyV7oi4ocniV
         fYGj/85xOIC+JYg17VeccFAzYYb9fiVU7B+NTj9FOwXEhbJb2Xtk6UZ66vbDCDojSl43
         HqykWGcWLWAriUZdFFxi/0H9zCXyZ+/qcjSHNGMZZEbOdeQO+wKmCKFVSR4eXZMPuzFJ
         Kmj584weAQJ/IzVhGyMcwzWYi+8R/ouqX/XLV9RbwkrGirKBeVaVtj0dRC9XqFcGbGoJ
         LvU5xNa3vjU20sgu9uEQFcucHhlnfk4KSjHphtLgvqABjW+0YNIqIkb/a8FFHrKfNosR
         biTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686645586; x=1689237586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I75s87zKIQdrkEMYwa6WVWiel4x5Y1zYxgEy0yTGKmQ=;
        b=GkMVem1jr+70oc4bXGcTUqwxOnOqvl3VBaQm1wCYwHrUfvZp+UO9AkE8eq1NCeg/A1
         LRu0tVZMkZcUnGGWNzFRmgQyHJ9/vGuSmEw5ThEra6GsI05+rG0hAsTGkS0xMmj9luSE
         M31yBqhfsw2QwDcCtW46MP6CP+X63Z6bKYe7AAmwT8u2kqUJTJmCgUvyptWcbA6kmTOP
         hRaHEqALGjm4Wmu2c9n0Vkywk4YySl7uFo65O5gZH1I1i452xfRLfX8dC/Y76/kjf0wQ
         Mm5Uw1IiWvYcF1HcEhgLa7iYKl/CGmMQfk0FZCagPsxSrqwuWlJJj9tF1B7EIwr8UOc8
         J0uQ==
X-Gm-Message-State: AC+VfDycH91dZQ5OGJEe36Je/Z/BUh0ujtixsdgM61uOHfXEMKnnV9qx
        iAUarG18nRsU8C5l8/LH7jENnbleFuX4c+UrfjY3xjdqZos=
X-Google-Smtp-Source: ACHHUZ7DV/mXErxggDsouFur/WfpcL3BfzbY2pS/ZhbWeJ34zbd8BdDsYi63mX7No0dYDYYVSSRlX9LmO04pOIsaFF0=
X-Received: by 2002:a17:907:3184:b0:962:9ffa:be02 with SMTP id
 xe4-20020a170907318400b009629ffabe02mr11636741ejb.36.1686645586087; Tue, 13
 Jun 2023 01:39:46 -0700 (PDT)
MIME-Version: 1.0
References: <20230612114359.220895-1-xiubli@redhat.com> <20230612114359.220895-2-xiubli@redhat.com>
In-Reply-To: <20230612114359.220895-2-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 13 Jun 2023 10:39:34 +0200
Message-ID: <CAOi1vP-u-UR-jd=ALxJTwjq4AJpQ7_=chMqwwBmrxsyQqXCqVQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] ceph: add the *_client debug macros support
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, khiremat@redhat.com, mchangir@redhat.com,
        pdonnell@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Mon, Jun 12, 2023 at 1:46=E2=80=AFPM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> This will help print the client's global_id in debug logs.

Hi Xiubo,

There is a related concern that clients can belong to different
clusters, in which case their global IDs might clash.  If you chose
to disregard that as an unlikely scenario, it's probably fine, but
it would be nice to make that explicit in the commit message.

If account for that, the identifier block could look like:

  [<cluster fsid> <gid>]

instead of:

  [client.<gid>]

The "client." string prefix seems a bit redundant since the kernel
client's entity is always CEPH_ENTITY_TYPE_CLIENT.  If you like it
anyway, I would at least get rid of the dot at the end to align with
how it's presented elsewhere (e.g. debugfs directory name or
"ceph.client_id" xattr).

Thanks,

                Ilya
