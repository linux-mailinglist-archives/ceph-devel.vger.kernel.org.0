Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 496CC72DEC1
	for <lists+ceph-devel@lfdr.de>; Tue, 13 Jun 2023 12:09:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238994AbjFMKJG (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Tue, 13 Jun 2023 06:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238315AbjFMKJE (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Tue, 13 Jun 2023 06:09:04 -0400
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0861CE6
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 03:09:04 -0700 (PDT)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9788faaca2dso889663466b.0
        for <ceph-devel@vger.kernel.org>; Tue, 13 Jun 2023 03:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686650942; x=1689242942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zRnQhC3R7v3Sueu5yVEDqAnqkD3Zz28DYnEfqpAWhCE=;
        b=Z4Rn50zVHsbcYYxd0ReCGBjUgH7gm5wcGOuSD21vnIsf7/ncuQeQKDq+OLPdGeMHm5
         /9qge/EBo/+nVGy6BSkSDhTdJuDaEMnGUTC4H4V59+HAXwcxc3u6L3a3dd033G7TJp1b
         dhKbT8NipjUgN+6FWPgaWzl4RiqV+Cf3QkDS6ugasWsbF8KCvKg5YV67rdYnSVeHtv9l
         gkC74uy4QnwjzSaFLROeMkvf/HwlhYj/pP71d4KCC9kWid9i3aTQj33jhrIVpCdIsSsN
         zbTauN0iSxWpOX/srdHFcHfMgnZB27VPahZeAysGk6/xsIxb90Dn31fukW5Th3spEE+/
         uS2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686650942; x=1689242942;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zRnQhC3R7v3Sueu5yVEDqAnqkD3Zz28DYnEfqpAWhCE=;
        b=IgVKb3RIjKffehSSvNDTqQ+SL82DLDQKaqYcGWBXij+6g9A2aZxijK5zKY4OWPYxof
         iNgwXzYb14iRqxowyDeMwRzfnEhuRGtojezeXsoYn1w2EHfKrYnQqJsshmanty7LMWsh
         wQOyEdgvk42V+kTej9UyLVpGG9AZHD2bpAiacAR+a5W3cRAFLxTh3iSTO3CbVc8tAy0s
         hXU6jGhzst0fZk3S6qWexO+i4/JhOQRRZRefBpU5TvlxGRhR//GiGdwwZOPL+Yt2O/BC
         HC/0lHLACuRYtW1bt2KuTZS6RKTbn1l6MzO0CsglQyI7XoEgDeEnxte+9OdFQYLv6oB0
         dmDA==
X-Gm-Message-State: AC+VfDx19ky7e+Dg+/XWfwozLvS0Hqy1QDUR3LcJbF911BpKGn2FnLvt
        jq/o+N4BAX9G3D7u/qITzSgwHRA5MFUGWjOuuSc=
X-Google-Smtp-Source: ACHHUZ7t72AgEnLnH+F5Kt3VIfHGfwtxzJOrSK2zku6Ak27XWxrvz6MmmC1PJ6Qsdxygk2fqxjSCJ5WCSVMsOjPSpSA=
X-Received: by 2002:a17:907:97d3:b0:977:c8a7:bed5 with SMTP id
 js19-20020a17090797d300b00977c8a7bed5mr12165846ejc.47.1686650942204; Tue, 13
 Jun 2023 03:09:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230612114359.220895-1-xiubli@redhat.com> <20230612114359.220895-2-xiubli@redhat.com>
 <CAOi1vP-u-UR-jd=ALxJTwjq4AJpQ7_=chMqwwBmrxsyQqXCqVQ@mail.gmail.com> <2a947e0d-5773-2032-c054-d99eeace1ddc@redhat.com>
In-Reply-To: <2a947e0d-5773-2032-c054-d99eeace1ddc@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Tue, 13 Jun 2023 12:08:50 +0200
Message-ID: <CAOi1vP8F2kyd1j_oAdj0CqX-0wqE4j7sTsoV62tQG7D7Ync93g@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] ceph: add the *_client debug macros support
To:     Xiubo Li <xiubli@redhat.com>
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

On Tue, Jun 13, 2023 at 11:27=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote=
:
>
>
> On 6/13/23 16:39, Ilya Dryomov wrote:
> > On Mon, Jun 12, 2023 at 1:46=E2=80=AFPM <xiubli@redhat.com> wrote:
> >> From: Xiubo Li <xiubli@redhat.com>
> >>
> >> This will help print the client's global_id in debug logs.
> > Hi Xiubo,
> >
> > There is a related concern that clients can belong to different
> > clusters, in which case their global IDs might clash.  If you chose
> > to disregard that as an unlikely scenario, it's probably fine, but
> > it would be nice to make that explicit in the commit message.
> >
> > If account for that, the identifier block could look like:
> >
> >    [<cluster fsid> <gid>]
>
> The fsid string is a little long:
>
> [5ea1e13c-4034-426c-bf8f-8a3a70d9e812 4236]
>
> Maybe we could just print part of that as:
>
> [5ea1e13c.. 4236]
>
> ?

If printing it at all, I would probably print the entire UUID.  But
I don't have a strong opinion here.

Thanks,

                Ilya
