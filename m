Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1A695456EA
	for <lists+ceph-devel@lfdr.de>; Fri, 10 Jun 2022 00:06:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345234AbiFIWGI (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 9 Jun 2022 18:06:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345198AbiFIWGG (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 9 Jun 2022 18:06:06 -0400
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BC21DA0B9
        for <ceph-devel@vger.kernel.org>; Thu,  9 Jun 2022 15:06:04 -0700 (PDT)
Received: by mail-ej1-x634.google.com with SMTP id g25so3597682ejh.9
        for <ceph-devel@vger.kernel.org>; Thu, 09 Jun 2022 15:06:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6UoMg7XAdZhjLF3+TuyFXMPmzf7hGCGFPyI+PbeCZf8=;
        b=bg+vgE40WdCztmrYjVSM/YJF9ZXtLor8NrvacxWrs8tmReVOyatbyF3+bwL2eQ+QeM
         h+OM4NPlRuZy2i1/Ro6kdbLrzQGd7SZNUFH7OSOKsX6tGe3TeNeXQa/eGc0tnjd1Yy2D
         IwGPT6SLiwVu0vhgUhkqA+ubHnvIUAQpO7X4w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6UoMg7XAdZhjLF3+TuyFXMPmzf7hGCGFPyI+PbeCZf8=;
        b=03VmAkGSPuOnlKf72e3nsXMFkFZOK3aTzDg+RBO+CaOAcEk3aTtmBu64jUdqCFXtF2
         0pnsI/RJopqpRj/8qMlC9SKy5NNziNH+ZS4iadt3xoeWxnz19LDvr8tQjvchwUk+vRXd
         nZZgzxw0sRhzkM40MVzXNsz1QXiH5G7deVX3Tars2DcMdrfQrBKSsyMU1adO+pSaxmYw
         8G8ay3yA34kTjy0y2PlLtFOGA0Dyfjz8CKtHdt+yHiqNx4PCvYKSKejcMbzHwTTuxA55
         yazoZ5r9dHZod5Jx+DNjzf4hv4Qe/WvHcFniwwfg0778K3BcaJO2q26mwOht71XMDp4d
         6Fdg==
X-Gm-Message-State: AOAM533hr777Pk+cDoqAxZjSMc/bVMEoJlgfUdl1Uyh1uGRiFPqK2kSy
        82ANi03pPvTrCAOK9ighhJ0po22kRZ79HjNDckE=
X-Google-Smtp-Source: ABdhPJyLZGrMzKdNO90xleAACOEJF9+Gj61z+bqvPcwTfZ5P1ud0bewn0kcL2nq1bbf+UBSGK8pUxQ==
X-Received: by 2002:a17:906:7791:b0:712:1c42:777a with SMTP id s17-20020a170906779100b007121c42777amr1372479ejm.68.1654812363626;
        Thu, 09 Jun 2022 15:06:03 -0700 (PDT)
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com. [209.85.128.52])
        by smtp.gmail.com with ESMTPSA id q2-20020a17090609a200b006f3ef214e63sm11237098eje.201.2022.06.09.15.06.03
        for <ceph-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jun 2022 15:06:03 -0700 (PDT)
Received: by mail-wm1-f52.google.com with SMTP id e5so6222476wma.0
        for <ceph-devel@vger.kernel.org>; Thu, 09 Jun 2022 15:06:03 -0700 (PDT)
X-Received: by 2002:a05:600c:42c6:b0:39c:4bfd:a4a9 with SMTP id
 j6-20020a05600c42c600b0039c4bfda4a9mr5442248wme.8.1654812362760; Thu, 09 Jun
 2022 15:06:02 -0700 (PDT)
MIME-Version: 1.0
References: <40676.1654807564@warthog.procyon.org.uk> <CAHk-=wgkwKyNmNdKpQkqZ6DnmUL-x9hp0YBnUGjaPFEAdxDTbw@mail.gmail.com>
In-Reply-To: <CAHk-=wgkwKyNmNdKpQkqZ6DnmUL-x9hp0YBnUGjaPFEAdxDTbw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Jun 2022 15:05:46 -0700
X-Gmail-Original-Message-ID: <CAHk-=whGrrF20LshkNGJ41UmNN13MU6x0_npwaJQi9cr626GQQ@mail.gmail.com>
Message-ID: <CAHk-=whGrrF20LshkNGJ41UmNN13MU6x0_npwaJQi9cr626GQQ@mail.gmail.com>
Subject: Re: [PATCH] netfs: Fix gcc-12 warning by embedding vfs inode in netfs_i_context
To:     David Howells <dhowells@redhat.com>
Cc:     Jeff Layton <jlayton@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        Marc Dionne <marc.dionne@auristor.com>,
        Xiubo Li <xiubli@redhat.com>,
        Ilya Dryomov <idryomov@gmail.com>,
        Steve French <smfrench@gmail.com>,
        William Kucharski <william.kucharski@oracle.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Dave Chinner <david@fromorbit.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        v9fs-developer@lists.sourceforge.net,
        linux-afs@lists.infradead.org, ceph-devel@vger.kernel.org,
        CIFS <linux-cifs@vger.kernel.org>,
        samba-technical@lists.samba.org,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-hardening@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Jun 9, 2022 at 3:04 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> IOW, I think you really should do something like the attached on top
> of this all.

Just to clarify: I did apply your patch. It's an improvement on what
used to go on.

I just think it wasn't as much of an improvement that it should have
been, and that largely untested patch I attached is I think another
step in a better direction.

                      Linus
