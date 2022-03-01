Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B637D4C926C
	for <lists+ceph-devel@lfdr.de>; Tue,  1 Mar 2022 18:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233410AbiCAR7l (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 1 Mar 2022 12:59:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232562AbiCAR7k (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 1 Mar 2022 12:59:40 -0500
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D35893ED3F
        for <ceph-devel@vger.kernel.org>; Tue,  1 Mar 2022 09:58:57 -0800 (PST)
Received: by mail-vs1-xe2b.google.com with SMTP id g20so17391935vsb.9
        for <ceph-devel@vger.kernel.org>; Tue, 01 Mar 2022 09:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Js2n67a3IZAisCL9ZHEc/syhLkHFIQ/9pIWOUpUXSQ=;
        b=qsq6GJTt3DFJMjpT3RQn1xgsgZvuLjiMHw6aVt4v4HaU5ptZrxzX+02h1xFuUo6W1Z
         JFwKQsluk4aUFofNnkrw5mAKLCRbS+Yl9zuCSyoLH275s7IGtpd4eb2f8pwMCvlqHHBd
         1hT0N5wShMbfLxSMWQZGh4YVd4D6RAfHX2Bnv0qdugjsHSeDOHDYcBTss2rZQ11FKUPd
         vSxmMgbvKvQm/PX7fmamSfOZHWZOplVu1BEk6vdy9MV9XEW56gUjENqj1x5+5mSO2OK0
         JaSwbSFuMPV1e0Fl9t7exHRtsskEhtDAqyraIA9pGjHQ0lfVSytcEQ2fBsVnda8BwSlr
         yf+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Js2n67a3IZAisCL9ZHEc/syhLkHFIQ/9pIWOUpUXSQ=;
        b=UTbJ384tzPEcwqZBHeDdRt64avN9rVmQTu5QNAV9Go8yBBtZ3Bw8RZ/1yClYM0kDY1
         Hbk7UOFhLggqBwc0LVA7QhmYGjFwN21I40IfVWpXtcp+mlNPyk7I2G/YGGMFaMmhCXdc
         FsJCDFXtUjg22LjdmZKqhIQ7403QUfmijS7lLLK07lul5yuvnIrh1XDD5zlQrpRuYd5G
         Axdf6M2tuFTJPtc9y8LoFWZo64rGMa2ppdOopFpIWZTqqGCqvBPJCXHPVN+RhBpRrxUJ
         Bm897xbQtLFm80w4Gg8Qw5vq5woufitepn9YH+KIhDzaUXlVITdHPWDJgOibkWpuxhrz
         cmGA==
X-Gm-Message-State: AOAM5320gitJFkdRSRqppOYcha+OaNVVnYdnmM6iJtdmI2JlU4569H89
        4ux1Us2JvPcZYTPKI7tM9LQCW+wxxv+WPWcTcg0=
X-Google-Smtp-Source: ABdhPJy5mIs+6RSUPU1W+E6hwlCMU/vgXtMQPj0ERukIibcZmOt/f6ddpEp9y+SfkDiMwXcbI+kIF/xtCTfdZIx2bHw=
X-Received: by 2002:a05:6102:22f8:b0:31c:db:7ed5 with SMTP id
 b24-20020a05610222f800b0031c00db7ed5mr11641176vsh.47.1646157537026; Tue, 01
 Mar 2022 09:58:57 -0800 (PST)
MIME-Version: 1.0
References: <3079339.1646142563@warthog.procyon.org.uk>
In-Reply-To: <3079339.1646142563@warthog.procyon.org.uk>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 1 Mar 2022 18:59:21 +0100
Message-ID: <CAOi1vP-42VTGJOqyWbpO4_kqn_1Sh9YLTgzPOo2F5KJFF+EyzQ@mail.gmail.com>
Subject: Re: Making 3 ceph patches available to rebase netfslib patches on
To:     David Howells <dhowells@redhat.com>
Cc:     Ceph Development <ceph-devel@vger.kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, Mar 1, 2022 at 2:49 PM David Howells <dhowells@redhat.com> wrote:
>
> Hi Ilya,
>
> Could you pick three ceph commits onto the branch you're going to use for the
> next merge window?  They're on the testing branch, but I'm assuming that's not
> going to be presented to Linus, given the do-not-merge commits it also has on
> it.
>
> I'd like to rebase my netfslib patchset on it so that we don't have two views
> of the same thing.
>
> The three commits are:
>
> 9579e41d45c961a52ffa619c4a77d78f2f782c19
> ceph: switch netfs read ops to use rreq->inode instead of rreq->mapping->host
>
> 85fc162016ac8d19e28877a15f55c0fa4b47713b
> ceph: Make ceph_netfs_issue_op() handle inlined data
>
> f9ee82ff4db2310eb4ba5458ef08f89eaa0b0c20
> ceph: Uninline the data on a file opened for writing

Hi David,

Done.

Thanks,

                Ilya
