Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4455A0CD0
	for <lists+ceph-devel@lfdr.de>; Thu, 25 Aug 2022 11:40:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231283AbiHYJkO (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 25 Aug 2022 05:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236497AbiHYJkN (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>); Thu, 25 Aug 2022 05:40:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C4FD43E70
        for <ceph-devel@vger.kernel.org>; Thu, 25 Aug 2022 02:40:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B00A91FD38;
        Thu, 25 Aug 2022 09:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1661420410; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vbDYlX28bRFpScz3ZBpYLsEIe6WNmtCQj7t+URs8spo=;
        b=qY2WdgnStkJAR+LPrCKkgqA+vZ6sVU+fE/H8D3EaiS6H/lLYLX/Mb36kcq01yK7zLVIW57
        KSIaPyGPAs7D+szkpwQEC+rgBs/br795u/AwfqGACfNz8ptTnY6QC+Cf3GEus81VOPUHmh
        j/+cU13Gcxg9stUp8be3qxAUtOJpQQ4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1661420410;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vbDYlX28bRFpScz3ZBpYLsEIe6WNmtCQj7t+URs8spo=;
        b=HZUDRus3SCFNWoFVgeoiqRyreY0pdSFhng5vbYoqH7OzJwjzpA6PfL4VvsJlJUUKAUm/mv
        ofz8Es9FkZBACDBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5A4E113A8E;
        Thu, 25 Aug 2022 09:40:10 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id JRw6E3pDB2MDTAAAMHmgww
        (envelope-from <lhenriques@suse.de>); Thu, 25 Aug 2022 09:40:10 +0000
Received: from localhost (brahms.olymp [local])
        by brahms.olymp (OpenSMTPD) with ESMTPA id b5078ca5;
        Thu, 25 Aug 2022 09:41:02 +0000 (UTC)
Date:   Thu, 25 Aug 2022 10:41:02 +0100
From:   =?iso-8859-1?Q?Lu=EDs?= Henriques <lhenriques@suse.de>
To:     Ilya Dryomov <idryomov@gmail.com>
Cc:     Jeff Layton <jlayton@kernel.org>, xiubli@redhat.com,
        ceph-devel@vger.kernel.org
Subject: Re: [PATCH] ceph: fix error handling in ceph_sync_write
Message-ID: <YwdDrguhbzhqMPgr@suse.de>
References: <20220824205331.473248-1-jlayton@kernel.org>
 <CAOi1vP9-kOHNjtSY0uEQP0bWwfn17BbiRbeuAmoCf2X9RrFHBA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOi1vP9-kOHNjtSY0uEQP0bWwfn17BbiRbeuAmoCf2X9RrFHBA@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

On Thu, Aug 25, 2022 at 10:32:56AM +0200, Ilya Dryomov wrote:
> On Wed, Aug 24, 2022 at 10:53 PM Jeff Layton <jlayton@kernel.org> wrote:
> >
> > ceph_sync_write has assumed that a zero result in req->r_result means
> > success. Testing with a recent cluster however shows the OSD returning
> > a non-zero length written here. I'm not sure whether and when this
> > changed, but fix the code to accept either result.
> >
> > Assume a negative result means error, and anything else is a success. If
> > we're given a short length, then return a short write.
> >
> > Signed-off-by: Jeff Layton <jlayton@kernel.org>
> > ---
> >  fs/ceph/file.c | 10 +++++++++-
> >  1 file changed, 9 insertions(+), 1 deletion(-)
> >
> > diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> > index 86265713a743..c0b2c8968be9 100644
> > --- a/fs/ceph/file.c
> > +++ b/fs/ceph/file.c
> > @@ -1632,11 +1632,19 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
> >                                           req->r_end_latency, len, ret);
> >  out:
> >                 ceph_osdc_put_request(req);
> > -               if (ret != 0) {
> > +               if (ret < 0) {
> >                         ceph_set_error_write(ci);
> >                         break;
> >                 }
> >
> > +               /*
> > +                * FIXME: it's unclear whether all OSD versions return the
> > +                * length written on a write. For now, assume that a 0 return
> > +                * means that everything got written.
> > +                */
> > +               if (ret && ret < len)
> > +                       len = ret;
> > +
> >                 ceph_clear_error_write(ci);
> >                 pos += len;
> >                 written += len;
> > --
> > 2.37.2
> >
> 
> Hi Jeff,
> 
> AFAIK OSDs aren't allowed to return any kind of length on a write
> and there is no such thing as a short write.  This definitely needs
> deeper investigation.
> 
> What is the cluster version you are testing against?

OK, I'm only seeing 'ret' being set to the write length only when enabling
encryption (i.e. with test_dummy_encryption mount option).  So, maybe the
right fix is something like:

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 16dcade66923..5119d87d61fb 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1889,6 +1889,7 @@ ceph_sync_write(struct kiocb *iocb, struct iov_iter *from, loff_t pos,
 				ceph_release_page_vector(pages, num_pages);
 				break;
 			}
+			ret = 0;
 		}
 
 		req = ceph_osdc_new_request(osdc, &ci->i_layout,

Cheers,
--
Luís
