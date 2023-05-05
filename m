Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95D06F8238
	for <lists+ceph-devel@lfdr.de>; Fri,  5 May 2023 13:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231875AbjEELmw (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Fri, 5 May 2023 07:42:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbjEELmv (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Fri, 5 May 2023 07:42:51 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D171A1F3
        for <ceph-devel@vger.kernel.org>; Fri,  5 May 2023 04:42:47 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 5939F1FE51;
        Fri,  5 May 2023 11:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1683286966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QrpYWD/sW3mSe6+9iy1Mvd5dW13BARjNR2IcK8vdZbs=;
        b=TC6tdDoj2C9840y1pBpkEGC+4r1h4fP4QKyLG+DLQNWIy0s8MmRog+JAnyus90B8OGh8Ru
        CWlOQ/yxsQEwiXX3cx1Ffy0e8DzcgjUQzUwuCXvLFnc35AwiQBoHZdj4kf2+dz1mbnM1ha
        8gXM4ZQ1YtiWWu1BYGXEQvV990rHVhw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1683286966;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QrpYWD/sW3mSe6+9iy1Mvd5dW13BARjNR2IcK8vdZbs=;
        b=Jk4UWqb0xIiQc0A03oYoroPF+zvSBJc8fn1n/gto4Snuq8rm4v0W5y/YuwYSmvyrDvjpkR
        L5vGinmtEGCXBzAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0E2C213488;
        Fri,  5 May 2023 11:42:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id +5WKO7XrVGQPIQAAMHmgww
        (envelope-from <lhenriques@suse.de>); Fri, 05 May 2023 11:42:45 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id e2557398;
        Fri, 5 May 2023 11:42:45 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Xiubo Li <xiubli@redhat.com>, ceph-devel@vger.kernel.org
Subject: Re: [GIT PULL] Ceph updates for 6.4-rc1
References: <20230504182810.165185-1-idryomov@gmail.com>
Date:   Fri, 05 May 2023 12:42:45 +0100
In-Reply-To: <20230504182810.165185-1-idryomov@gmail.com> (Ilya Dryomov's
        message of "Thu, 4 May 2023 20:28:10 +0200")
Message-ID: <87wn1nm2bu.fsf@brahms.olymp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org


[re-arranged CC list]

Ilya Dryomov <idryomov@gmail.com> writes:

> Hi Linus,
>
> The following changes since commit 457391b0380335d5e9a5babdec90ac53928b23=
b4:
>
>   Linux 6.3 (2023-04-23 12:02:52 -0700)
>
> are available in the Git repository at:
>
>   https://github.com/ceph/ceph-client.git tags/ceph-for-6.4-rc1
>
> for you to fetch changes up to db2993a423e3fd0e4878f4d3ac66fe717f5f072e:
>
>   ceph: reorder fields in 'struct ceph_snapid_map' (2023-04-30 12:37:28 +=
0200)
>
> ----------------------------------------------------------------
> A few filesystem improvements, with a rather nasty use-after-free fix
> from Xiubo intended for stable.

Thank you, Ilya.  It's unfortunate that fscrypt support misses yet another
merge window, but I guess there are still a few loose ends.

Is there a public list of issues (kernel or ceph proper) still to be
sorted out before this feature gets merged?  Or is this just a lack of
confidence on the implementation stability?

Cheers
--=20
Lu=C3=ADs
