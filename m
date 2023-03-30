Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 513EA6CFF60
	for <lists+ceph-devel@lfdr.de>; Thu, 30 Mar 2023 11:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjC3JAS (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 30 Mar 2023 05:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230409AbjC3JAF (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 30 Mar 2023 05:00:05 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0CCA7AA2
        for <ceph-devel@vger.kernel.org>; Thu, 30 Mar 2023 01:59:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B0B3C1FEAE;
        Thu, 30 Mar 2023 08:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1680166788; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Ts5+u2w1dfkiUhRTfFtxGPum5xcUjcxn6P2Y/6aobc=;
        b=CA9Y7nraQy7bnBqdvdTiPGCxkOXfJ4c/tc4l//d0E9NTKudNrL0eW4FpXWIZNBYOXRShE4
        kVmuWSx/90Ay8jR7YoiuM5Fp2hOxg8kmSIILFNUqKAzow0rywiWH1zv920k3Jaro5MYY7A
        Smjk/ekBq70GiD7HoNwrX5edX/edLwc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1680166788;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+Ts5+u2w1dfkiUhRTfFtxGPum5xcUjcxn6P2Y/6aobc=;
        b=N+G/jbDya4AGVW1ILtAB9DXBSJjPGLzJzPgwf9NcYvOnFx4yFDu/XBLAgDgMFzxOXeg++q
        r/+a9ifSJrlvR2AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 4AC4D1348E;
        Thu, 30 Mar 2023 08:59:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4ftTD4RPJWTDJwAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 30 Mar 2023 08:59:48 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id dd7adcd7;
        Thu, 30 Mar 2023 08:59:47 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Xiubo Li <xiubli@redhat.com>
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        vshankar@redhat.com, mchangir@redhat.com
Subject: Re: [PATCH v4] ceph: drop the messages from MDS when unmounting
References: <20230327030508.310588-1-xiubli@redhat.com>
        <87v8ij4o3m.fsf@suse.de>
        <cc0f3aac-39be-4dd3-dc5e-611923680047@redhat.com>
Date:   Thu, 30 Mar 2023 09:59:47 +0100
In-Reply-To: <cc0f3aac-39be-4dd3-dc5e-611923680047@redhat.com> (Xiubo Li's
        message of "Thu, 30 Mar 2023 09:33:10 +0800")
Message-ID: <87r0t64nss.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Xiubo Li <xiubli@redhat.com> writes:
> On 29/03/2023 22:41, Lu=C3=ADs Henriques wrote:
<...>
> This also looks good to me. As I remembered when reading the kernel code =
I just
> saw another place in VFS is also doing like this and I just followed it.
>> But... even with my suggestion, can't we deadlock here if we get preempt=
ed
>> just before the wait_for_completion() and ceph_dec_stopping_blocker() is
>> executed?
>
> Good question. Actually it won't.

Yeah, you're right.  Doh!

> The 'x->done' member in the completion will be initialized as 0, and the
> complete_all() will set it to 'UINT_MAX'. And only when 'x->done =3D=3D 0=
' will the
> wait_for_completion() go to sleep and wait.

Cheers,
--=20
Lu=C3=ADs
