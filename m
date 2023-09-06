Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44D91793DEA
	for <lists+ceph-devel@lfdr.de>; Wed,  6 Sep 2023 15:43:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235605AbjIFNng (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Wed, 6 Sep 2023 09:43:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232753AbjIFNne (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Wed, 6 Sep 2023 09:43:34 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32FA310F5
        for <ceph-devel@vger.kernel.org>; Wed,  6 Sep 2023 06:43:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D999C223D1;
        Wed,  6 Sep 2023 13:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1694007808; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2yZAM28MDR050Z1ZaeXOhfq3YpvTlgAoA8vEBfF+MmQ=;
        b=xRZfY8v+txQ1JhGCiGoM8/YEm4NOpMd9j1q3/xq6jB0KILz2cut8QqA6SVjBvxHKqS/P8r
        th1T7yd23BrIMwLhHfzymq+EYxbjDEuW7vgLE0ME/AFuvqvWpg82ey7GFeUwxz4iKxc06d
        utJd9S8kjGWDL8lynJ7eVDzSftkOXwo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1694007808;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2yZAM28MDR050Z1ZaeXOhfq3YpvTlgAoA8vEBfF+MmQ=;
        b=LqgyXlrPBh7wEMjOR4R3YbpBSbxlkSpvF0Xs0wj69QhKaNFzoccMxtpeDs+QFg/idOToKW
        j2AyS+tvVdnOo4Dg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9DA871333E;
        Wed,  6 Sep 2023 13:43:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vWdBIwCC+GSgJAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Wed, 06 Sep 2023 13:43:28 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id 7e8f3001;
        Wed, 6 Sep 2023 13:43:27 +0000 (UTC)
From:   =?utf-8?Q?Lu=C3=ADs_Henriques?= <lhenriques@suse.de>
To:     Dan Carpenter <dan.carpenter@linaro.org>
Cc:     Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org
Subject: Re: [bug report] ceph: add support for encrypted snapshot names
In-Reply-To: <940a3e16-50d2-407b-bf45-b794bad64c3f@moroto.mountain> (Dan
        Carpenter's message of "Wed, 6 Sep 2023 15:34:36 +0300")
References: <940a3e16-50d2-407b-bf45-b794bad64c3f@moroto.mountain>
Date:   Wed, 06 Sep 2023 14:43:27 +0100
Message-ID: <87tts7beo0.fsf@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Dan Carpenter <dan.carpenter@linaro.org> writes:

> Hello Lu=C3=ADs Henriques,
>
> The patch dd66df0053ef: "ceph: add support for encrypted snapshot
> names" from Aug 25, 2022 (linux-next), leads to the following Smatch
> static checker warning:
>
> 	fs/ceph/crypto.c:252 parse_longname()
> 	warn: 'dir' is an error pointer or valid
>
> fs/ceph/crypto.c
>     211 static struct inode *parse_longname(const struct inode *parent,
>     212                                     const char *name, int *name_l=
en)
>     213 {
>     214         struct inode *dir =3D NULL;
>     215         struct ceph_vino vino =3D { .snap =3D CEPH_NOSNAP };
>     216         char *inode_number;
>     217         char *name_end;
>     218         int orig_len =3D *name_len;
>     219         int ret =3D -EIO;
>     220=20
>     221         /* Skip initial '_' */
>     222         name++;
>     223         name_end =3D strrchr(name, '_');
>     224         if (!name_end) {
>     225                 dout("Failed to parse long snapshot name: %s\n", =
name);
>     226                 return ERR_PTR(-EIO);
>     227         }
>     228         *name_len =3D (name_end - name);
>     229         if (*name_len <=3D 0) {
>     230                 pr_err("Failed to parse long snapshot name\n");
>     231                 return ERR_PTR(-EIO);
>     232         }
>     233=20
>     234         /* Get the inode number */
>     235         inode_number =3D kmemdup_nul(name_end + 1,
>     236                                    orig_len - *name_len - 2,
>     237                                    GFP_KERNEL);
>     238         if (!inode_number)
>     239                 return ERR_PTR(-ENOMEM);
>     240         ret =3D kstrtou64(inode_number, 10, &vino.ino);
>     241         if (ret) {
>     242                 dout("Failed to parse inode number: %s\n", name);
>     243                 dir =3D ERR_PTR(ret);
>     244                 goto out;
>     245         }
>     246=20
>     247         /* And finally the inode */
>     248         dir =3D ceph_find_inode(parent->i_sb, vino);
>     249         if (!dir) {
>     250                 /* This can happen if we're not mounting cephfs o=
n the root */
>     251                 dir =3D ceph_get_inode(parent->i_sb, vino, NULL);
> --> 252                 if (!dir)
>     253                         dir =3D ERR_PTR(-ENOENT);
>
> This never returns NULL.  If it were tempted to return NULL then it
> returns -ENOMEM instead.

Oops, you're right.  But the fix should be as easy as removing that 'if'
statement and let this function simply return 'dir' as-is.

I'll send out an updated version of the patch in reply to this email.
Thanks for the report, Dan.

Cheers,
--=20
Lu=C3=ADs

>
>     254         }
>     255         if (IS_ERR(dir))
>     256                 dout("Can't find inode %s (%s)\n", inode_number, =
name);
>     257=20
>     258 out:
>     259         kfree(inode_number);
>     260         return dir;
>     261 }
>
> regards,
> dan carpenter
