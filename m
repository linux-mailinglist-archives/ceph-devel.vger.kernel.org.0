Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 812815431EF
	for <lists+ceph-devel@lfdr.de>; Wed,  8 Jun 2022 15:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240936AbiFHNve (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 8 Jun 2022 09:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240883AbiFHNvb (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 8 Jun 2022 09:51:31 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7A7CA104C86
        for <ceph-devel@vger.kernel.org>; Wed,  8 Jun 2022 06:51:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1654696288;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lEIfsnCA3X8Wk3O0XuKpv23cpCZ/glug4+HBXuKXDUA=;
        b=Go9XPXfO+hO2nDUWBpJAou31mtf1c+sECkfRX/7AcBr8dEy/NuNkX4vvtRUqkFk0WPiMub
        OV2q4aQLwFqRi1NViRhVQD62myL8lN9t/rBqjByv0fTOGoIUKhPzh6VjFTxxd6FGj0qqXb
        T5E5DoKxK8GDZWD9LUc62XNxDLuUGdI=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-496-AgdQFaxNMrm47TPLqBDeuQ-1; Wed, 08 Jun 2022 09:51:21 -0400
X-MC-Unique: AgdQFaxNMrm47TPLqBDeuQ-1
Received: by mail-qk1-f200.google.com with SMTP id bq11-20020a05620a468b00b006a71592a2abso675312qkb.21
        for <ceph-devel@vger.kernel.org>; Wed, 08 Jun 2022 06:51:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:content-transfer-encoding:user-agent:mime-version;
        bh=lEIfsnCA3X8Wk3O0XuKpv23cpCZ/glug4+HBXuKXDUA=;
        b=PhbMPI2AzdN3eO6FcUMnuFNNK+UtTN0T2pkKRwdHrwbLdrDyzG2C31pPLP1w4ocUMD
         L0HZBzivt9IhoZlrGeY8prP4ZCYBx/IwDLG5MmQ/bm9ylEKFtANEP+p2NRapKN/7f31a
         /UVcf4XY7DWi/lKJafJuHFfvWp+ZtQ4LhwUG59EYu4YBKSIFEbMXqiqch34hJ0/gOZYP
         zAoDOv2akV6wMxaKAbcAZ0ObvNQAkR6wMuo2mClyzrDjQW/UoczLMIC2xnwOLC8lBvSg
         NzI7seiH3kY5tt6Geziy+fKdhJ8E5dloAdgKPsJR3elRZcH1qrM+tfvVg6bk/3xYgbZk
         rSeQ==
X-Gm-Message-State: AOAM532iMkEIUBxiOwfySLz+guIsr2INIILGY1gB1a7Ud++IQUPSRPqn
        7rz1pPZkzDDjzuUdvbaGA2lAzsMMqsjUtE91vZk9vmbQBDtMfw06MGCkYh1fTHj1jsAfs43K/WE
        jhaxWmqd/oAgJs+1xgahSHQ==
X-Received: by 2002:a05:620a:462b:b0:6a3:9c74:85cf with SMTP id br43-20020a05620a462b00b006a39c7485cfmr23117306qkb.107.1654696280813;
        Wed, 08 Jun 2022 06:51:20 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxK0TzLzn9EAwqKpG9+DMx+ZYWibe8Y2wJkIU9H1oEFO3F2lY3l4Jxtju5ThTminI4Qk91aFA==
X-Received: by 2002:a05:620a:462b:b0:6a3:9c74:85cf with SMTP id br43-20020a05620a462b00b006a39c7485cfmr23117295qkb.107.1654696280571;
        Wed, 08 Jun 2022 06:51:20 -0700 (PDT)
Received: from [192.168.1.3] (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id l30-20020a37f91e000000b006a3325fd985sm16128225qkj.13.2022.06.08.06.51.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jun 2022 06:51:20 -0700 (PDT)
Message-ID: <6b992c9fe9e564eef7ad12ca5673ac9ebd9c3ef6.camel@redhat.com>
Subject: Re: cephfs snapc writeback order
From:   Jeff Layton <jlayton@redhat.com>
To:     Sage Weil <sage@newdream.net>
Cc:     ceph-devel <ceph-devel@vger.kernel.org>, dev <dev@ceph.io>,
        Xiubo Li <xiubli@redhat.com>,
        Gregory Farnum <gfarnum@redhat.com>,
        David Howells <dhowells74@googlemail.com>
Date:   Wed, 08 Jun 2022 09:51:19 -0400
In-Reply-To: <CAN0f57GxvOh4uyqrwkHz=WjS_fR0dunDFxMeeTPMP3Gu+AR5Cg@mail.gmail.com>
References: <8ea706f2b7eec229c645e5c122689f5acc087671.camel@redhat.com>
         <CAN0f57GxvOh4uyqrwkHz=WjS_fR0dunDFxMeeTPMP3Gu+AR5Cg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.2 (3.44.2-1.fc36) 
MIME-Version: 1.0
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Tue, 2022-06-07 at 14:04 -0500, Sage Weil wrote:
> Hi Jeff!
>=20
> On Tue, Jun 7, 2022 at 1:21 PM Jeff Layton <jlayton@redhat.com> wrote:
> > I'm taking a stab at converting ceph to use the netfs write helpers.
> > One
> > thing I'm seeing though is that the kclient takes great care to
> > write
> > back data to the OSDs in order of snap context age, such that an
> > older
> > snapc will get written back before a newer one. With the netfs
> > helpers,
> > that may not happen quite as naturally. We may end up with it trying
> > to
> > flush data for a newer snapc ahead of the older one.
> >=20
> > My question is: is that necessarily a problem? We'd be sending along
> > the
> > correct info from the capsnap for each snapc, which seems like it
> > should
> > be sufficient to ensure that the writes get applied correctly. If we
> > were to send these out of order, what would break and how?
> >=20
>=20
>=20
> Writing back snapshotted data out of order would corrupt the snapshot
> content.=A0 The OSD can only create clone objects (snapshotted data)
> from the live/head/most recent version of the object it has, which
> means that a newer write followed by an older one will apply the old
> data to the newer object.=A0 Exactly how that shakes out depends on
> where the writes are relative to object boundaries (the cloning on the
> OSD is by object) and how the writes were ordered relative to the
> snapshots, but in any case the end result will not be correct.
>=20

Got it, thanks. Also thanks to Greg for his response.

> :( Hopefully that doesn't make the netfs transition unworkable!
>=20


No, it doesn't make the transition unworkable, but we'll need to
implement something in the netfs layer to ensure that things get written
back in the correct order. David and I are still discussing what to do,
but it should be doable.

--=20
Jeff Layton <jlayton@redhat.com>

