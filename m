Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5F537BE35F
	for <lists+ceph-devel@lfdr.de>; Mon,  9 Oct 2023 16:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234551AbjJIOpw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Mon, 9 Oct 2023 10:45:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232503AbjJIOpv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Mon, 9 Oct 2023 10:45:51 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DD8B0
        for <ceph-devel@vger.kernel.org>; Mon,  9 Oct 2023 07:45:50 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id 38308e7fff4ca-2c135cf2459so52684101fa.0
        for <ceph-devel@vger.kernel.org>; Mon, 09 Oct 2023 07:45:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1696862748; x=1697467548; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GZgrGHyhh24SlGacSkXVqyUBpWvWe6J5YeMe4c0ejHI=;
        b=YC7Hw6NHS/83/jDb1jFWz7Akqjm+CBmaGIozGIRfXltiGI+gKqpd4jv3tpConA7Cx5
         6pAU/ThbnVIgOSFAcigjDv1LlVKBlbjdhVMOa32xRthBnrnNYmxABuii9aczcmLUXw4C
         wBM17Lv+WLbtLuiIJGkt4eoqyZ+FMDfnRy57bhpjYvGLXs0KAkZZf0VOa6yUv52w0nnU
         YXIjXntYfWoIDio6hdwbDic/ooJDi3Ng7evR9DRNyfgERA9SZI8TUehZ75621Zd8U+m1
         hiu6MqD93PmgwhLPfPLiIn3Oexxs0k9PlyG5T8bIERbLPGKPqsO3w5Zsucy9I0SVt7VB
         oemQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696862748; x=1697467548;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GZgrGHyhh24SlGacSkXVqyUBpWvWe6J5YeMe4c0ejHI=;
        b=OFxl73TvxsP58OXs3ihj+VBGjypdLc5b0306K5l0mkaDgsArssui0f5bPhd/P618rS
         Ec/ipZXwheAoOaFh82T5wOw/14AByxskkavVmLRouKz43q5jmxWS1eQCIeopwpmvkzkq
         0pUe2Ggk6vk5YtYUwX3v7fiazbwvsFTFggdonKDrnGT+UmHIsn2OudoJf4aLTZ/LR+Sf
         5SK6XGnXKJS+jr8w4U3nj15eHtEsI1yw4CJb9Ap70smX06MW9Viy9zFvJUkq1Oujo5OG
         vxCPugY+NKf0fjjuKlZfMdNuFFcZyFB6J14XEn/tz4QF0ldYu9ZC7SpR+GoXKflBSBg0
         rdaQ==
X-Gm-Message-State: AOJu0Yygg7A2eDFCyqthNnvGscH2rCVG9TS/zlujZb81EhJx4cgR2HsJ
        YJnONtqjSQUZ5kpHAG5ouB95zXfbr681rmVGZW3Gcg==
X-Google-Smtp-Source: AGHT+IEDF91AvHzJpEgtXdwIiAxumKeC+rEr/GbEpvbUT0VJVZba6pc2wxKxrHSdG/c5v7SZWrawJk6SFkdCVO2SYiE=
X-Received: by 2002:a2e:7204:0:b0:2c0:21b6:e80c with SMTP id
 n4-20020a2e7204000000b002c021b6e80cmr13617400ljc.35.1696862748450; Mon, 09
 Oct 2023 07:45:48 -0700 (PDT)
MIME-Version: 1.0
References: <20230919081900.1096840-1-max.kellermann@ionos.com> <69dda7be-d7c8-401f-89f3-7a5ca5550e2f@oracle.com>
In-Reply-To: <69dda7be-d7c8-401f-89f3-7a5ca5550e2f@oracle.com>
From:   Max Kellermann <max.kellermann@ionos.com>
Date:   Mon, 9 Oct 2023 16:45:37 +0200
Message-ID: <CAKPOu+9aeEXf=HdVMeG-o17NeDZd8=+LGxD4QYER2ibUPbH6kw@mail.gmail.com>
Subject: Re: [PATCH] fs: apply umask if POSIX ACL support is disabled
To:     Dave Kleikamp <dave.kleikamp@oracle.com>
Cc:     Xiubo Li <xiubli@redhat.com>, Ilya Dryomov <idryomov@gmail.com>,
        Jeff Layton <jlayton@kernel.org>, Jan Kara <jack@suse.com>,
        ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org, jfs-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Oct 3, 2023 at 5:32=E2=80=AFPM Dave Kleikamp <dave.kleikamp@oracle.=
com> wrote:
> I think this is sane, but the patch needs a description of why this is
> necessary for these specific file systems.

Indeed the patch description was lacking, sorry. I sent v2 with a
better description.

Max
