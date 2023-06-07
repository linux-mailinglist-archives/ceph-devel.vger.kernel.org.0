Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01F247259F7
	for <lists+ceph-devel@lfdr.de>; Wed,  7 Jun 2023 11:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235201AbjFGJUH (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 7 Jun 2023 05:20:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239927AbjFGJTV (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 7 Jun 2023 05:19:21 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0218D2129
        for <ceph-devel@vger.kernel.org>; Wed,  7 Jun 2023 02:18:51 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 9F71C1FDAD;
        Wed,  7 Jun 2023 09:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1686129529; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=knpchvv8uy2aGYQLMhF1sVSwEvzepVZHCSYI7abtzDQ=;
        b=hP2PNpjouRVmlLtTHg+1ymUA0hccus7RgMOKW4qySYQG59iWCaHj9E3JAq+asE13giXebs
        LW5x9ljn8TEIhB4ptk9pWZ3aABiRVYz9R4RTM65nhsVtDZ3hxNvHmtEB9Wdz4aHMwl079r
        /zFFqjrkzS+NZQrD9b+TTbxbJCBDyiE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1686129529;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=knpchvv8uy2aGYQLMhF1sVSwEvzepVZHCSYI7abtzDQ=;
        b=ixnUz3kJLcivHTbhpA+6eQ4Hxl48hRGYmwMKOy1L8uhklaZmzyPjlfua/qKlRBgGo0N4xL
        GDigpuESNjKpBWDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3966313776;
        Wed,  7 Jun 2023 09:18:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id x1EGC3lLgGQwWgAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 07 Jun 2023 09:18:49 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id d1d76951;
        Wed, 7 Jun 2023 09:18:48 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com
Subject: Re: [PATCH v2 0/2] ceph: fix fscrypt_destroy_keyring use-after-free
 bug
References: <20230606033212.1068823-1-xiubli@redhat.com>
        <87pm689asx.fsf@suse.de>
        <7ab9007b-763b-aacf-2297-62f1989e2efd@redhat.com>
Date:   Wed, 07 Jun 2023 10:18:48 +0100
In-Reply-To: <7ab9007b-763b-aacf-2297-62f1989e2efd@redhat.com> (Xiubo Li's
        message of "Tue, 6 Jun 2023 20:29:40 +0800")
Message-ID: <87h6rj8wav.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Xiubo Li <xiubli@redhat.com> writes:

> On 6/6/23 17:53, Lu=C3=ADs Henriques wrote:
>> xiubli@redhat.com writes:
>>
>>> From: Xiubo Li <xiubli@redhat.com>
>>>
>>> V2:
>>> - Improve the code by switching to wait_for_completion_killable_timeout=
()
>>>    when umounting, at the same add one umount_timeout option.
>> Instead of adding yet another (undocumented!) mount option, why not re-u=
se
>> the already existent 'mount_timeout' instead?  It's already defined and
>> kept in 'struct ceph_options', and the default value is defined with the
>> same value you're using, in CEPH_MOUNT_TIMEOUT_DEFAULT.
>
> This is for mount purpose. Is that okay to use the in umount case ?

Yeah, you're probably right.  It's just that adding yet another knob for a
corner case that probably will never be used and very few people will know
about is never a good thing (IMO).  Anyway, I think that at least this new
mount option needs to be mentioned in 'Documentation/filesystems/ceph.rst'.

Cheers,
--=20
Lu=C3=ADs
