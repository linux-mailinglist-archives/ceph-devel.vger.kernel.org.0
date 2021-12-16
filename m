Return-Path: <ceph-devel-owner@vger.kernel.org>
X-Original-To: lists+ceph-devel@lfdr.de
Delivered-To: lists+ceph-devel@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8FE477708
	for <lists+ceph-devel@lfdr.de>; Thu, 16 Dec 2021 17:09:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238838AbhLPQI7 (ORCPT <rfc822;lists+ceph-devel@lfdr.de>);
        Thu, 16 Dec 2021 11:08:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49526 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S238844AbhLPQI6 (ORCPT
        <rfc822;ceph-devel@vger.kernel.org>);
        Thu, 16 Dec 2021 11:08:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639670938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=96fJM0D9+gvF4u8p872ZFyBMH+2zffawIcbOyALr1kk=;
        b=LwL8IQHS1Zr+8KDWV/3rssFuh3E6JqzN9V6kaWinJjADDYSqYCLjtnPpn7ZuO/arb+LVMu
        gxL5N1pJGNXPafuXCcp9UxXeWRKoGsTlyovc4mjPlJc5xDxzsBivMNTR8jQ+bLATrG+L4Z
        uvh+pN1s681NKWWfkcQ0K4L5YcSbhuc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-160-PnIPnzeUO4KVZ-2xh12lkg-1; Thu, 16 Dec 2021 11:08:56 -0500
X-MC-Unique: PnIPnzeUO4KVZ-2xh12lkg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8814F104FC13;
        Thu, 16 Dec 2021 16:08:54 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.33.36.122])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EF4AB7959E;
        Thu, 16 Dec 2021 16:08:05 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
        Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
        Kingdom.
        Registered in England and Wales under Company Registration No. 3798903
Subject: [PATCH v3 10/68] fscache: Implement cookie registration
From:   David Howells <dhowells@redhat.com>
To:     linux-cachefs@redhat.com
Cc:     dhowells@redhat.com, Trond Myklebust <trondmy@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Steve French <sfrench@samba.org>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Jeff Layton <jlayton@kernel.org>,
        Matthew Wilcox <willy@infradead.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Omar Sandoval <osandov@osandov.com>,
        JeffleXu <jefflexu@linux.alibaba.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-afs@lists.infradead.org, linux-nfs@vger.kernel.org,
        linux-cifs@vger.kernel.org, ceph-devel@vger.kernel.org,
        v9fs-developer@lists.sourceforge.net,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 16 Dec 2021 16:08:05 +0000
Message-ID: <163967088507.1823006.12659006350221417165.stgit@warthog.procyon.org.uk>
In-Reply-To: <163967073889.1823006.12237147297060239168.stgit@warthog.procyon.org.uk>
References: <163967073889.1823006.12237147297060239168.stgit@warthog.procyon.org.uk>
User-Agent: StGit/0.23
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <ceph-devel.vger.kernel.org>
X-Mailing-List: ceph-devel@vger.kernel.org

Add functions to the fscache API to allow data file cookies to be acquired
and relinquished by the network filesystem.  It is intended that the
filesystem will create such cookies per-inode under a volume.

To request a cookie, the filesystem should call:

	struct fscache_cookie *
	fscache_acquire_cookie(struct fscache_volume *volume,
			       u8 advice,
			       const void *index_key,
			       size_t index_key_len,
			       const void *aux_data,
			       size_t aux_data_len,
			       loff_t object_size)


The filesystem must first have created a volume cookie, which is passed in
here.  If it passes in NULL then the function will just return a NULL
cookie.

A binary key should be passed in index_key and is of size index_key_len.
This is saved in the cookie and is used to locate the associated data in
the cache.

A coherency data buffer of size aux_data_len will be allocated and
initialised from the buffer pointed to by aux_data.  This is used to
validate cache objects when they're opened and is stored on disk with them
when they're committed.  The data is stored in the cookie and will be
updateable by various functions in later patches.

The object_size must also be given.  This is also used to perform a
coherency check and to size the backing storage appropriately.

This function disallows a cookie from being acquired twice in parallel,
though it will cause the second user to wait if the first is busy
relinquishing its cookie.


When a network filesystem has finished with a cookie, it should call:

	void
	fscache_relinquish_cookie(struct fscache_volume *volume,
				  bool retire)

If retire is true, any backing data will be discarded immediately.

Changes
=======
ver #3:
 - fscache_hash()'s size parameter is now in bytes.  Use __le32 as the unit
   to round up to.
 - When comparing cookies, simply see if the attributes are the same rather
   than subtracting them to produce a strcmp-style return[1].
 - Add a check to see if the cookie is still hashed at the point of
   freeing.

ver #2:
 - Don't hold n_accesses elevated whilst cache is bound to a cookie, but
   rather add a flag that prevents the state machine from being queued when
   n_accesses reaches 0.
 - Remove the unused cookie pointer field from the fscache_acquire
   tracepoint.

Signed-off-by: David Howells <dhowells@redhat.com>
cc: linux-cachefs@redhat.com
Link: https://lore.kernel.org/r/CAHk-=whtkzB446+hX0zdLsdcUJsJ=8_-0S1mE_R+YurThfUbLA@mail.gmail.com/ [1]
Link: https://lore.kernel.org/r/163819590658.215744.14934902514281054323.stgit@warthog.procyon.org.uk/ # v1
Link: https://lore.kernel.org/r/163906891983.143852.6219772337558577395.stgit@warthog.procyon.org.uk/ # v2
---

 fs/fscache/Makefile            |    1 
 fs/fscache/cookie.c            |  497 ++++++++++++++++++++++++++++++++++++++++
 fs/fscache/internal.h          |   23 ++
 fs/fscache/main.c              |   12 +
 fs/fscache/proc.c              |    4 
 fs/fscache/stats.c             |   28 ++
 include/linux/fscache-cache.h  |   22 ++
 include/linux/fscache.h        |  134 +++++++++++
 include/trace/events/fscache.h |  111 +++++++++
 9 files changed, 831 insertions(+), 1 deletion(-)
 create mode 100644 fs/fscache/cookie.c

diff --git a/fs/fscache/Makefile b/fs/fscache/Makefile
index bb5282ae682f..bcc79615f93a 100644
--- a/fs/fscache/Makefile
+++ b/fs/fscache/Makefile
@@ -5,6 +5,7 @@
 
 fscache-y := \
 	cache.o \
+	cookie.o \
 	main.o \
 	volume.o
 
diff --git a/fs/fscache/cookie.c b/fs/fscache/cookie.c
new file mode 100644
index 000000000000..438b0098aa73
--- /dev/null
+++ b/fs/fscache/cookie.c
@@ -0,0 +1,497 @@
+// SPDX-License-Identifier: GPL-2.0-or-later
+/* netfs cookie management
+ *
+ * Copyright (C) 2021 Red Hat, Inc. All Rights Reserved.
+ * Written by David Howells (dhowells@redhat.com)
+ *
+ * See Documentation/filesystems/caching/netfs-api.rst for more information on
+ * the netfs API.
+ */
+
+#define FSCACHE_DEBUG_LEVEL COOKIE
+#include <linux/module.h>
+#include <linux/slab.h>
+#include "internal.h"
+
+struct kmem_cache *fscache_cookie_jar;
+
+static void fscache_drop_cookie(struct fscache_cookie *cookie);
+
+#define fscache_cookie_hash_shift 15
+static struct hlist_bl_head fscache_cookie_hash[1 << fscache_cookie_hash_shift];
+static LIST_HEAD(fscache_cookies);
+static DEFINE_RWLOCK(fscache_cookies_lock);
+static const char fscache_cookie_states[FSCACHE_COOKIE_STATE__NR] = "-LCAFWRD";
+
+void fscache_print_cookie(struct fscache_cookie *cookie, char prefix)
+{
+	const u8 *k;
+
+	pr_err("%c-cookie c=%08x [fl=%lx na=%u nA=%u s=%c]\n",
+	       prefix,
+	       cookie->debug_id,
+	       cookie->flags,
+	       atomic_read(&cookie->n_active),
+	       atomic_read(&cookie->n_accesses),
+	       fscache_cookie_states[cookie->state]);
+	pr_err("%c-cookie V=%08x [%s]\n",
+	       prefix,
+	       cookie->volume->debug_id,
+	       cookie->volume->key);
+
+	k = (cookie->key_len <= sizeof(cookie->inline_key)) ?
+		cookie->inline_key : cookie->key;
+	pr_err("%c-key=[%u] '%*phN'\n", prefix, cookie->key_len, cookie->key_len, k);
+}
+
+static void fscache_free_cookie(struct fscache_cookie *cookie)
+{
+	if (WARN_ON_ONCE(test_bit(FSCACHE_COOKIE_IS_HASHED, &cookie->flags))) {
+		fscache_print_cookie(cookie, 'F');
+		return;
+	}
+
+	write_lock(&fscache_cookies_lock);
+	list_del(&cookie->proc_link);
+	write_unlock(&fscache_cookies_lock);
+	if (cookie->aux_len > sizeof(cookie->inline_aux))
+		kfree(cookie->aux);
+	if (cookie->key_len > sizeof(cookie->inline_key))
+		kfree(cookie->key);
+	fscache_stat_d(&fscache_n_cookies);
+	kmem_cache_free(fscache_cookie_jar, cookie);
+}
+
+static inline void wake_up_cookie_state(struct fscache_cookie *cookie)
+{
+	/* Use a barrier to ensure that waiters see the state variable
+	 * change, as spin_unlock doesn't guarantee a barrier.
+	 *
+	 * See comments over wake_up_bit() and waitqueue_active().
+	 */
+	smp_mb();
+	wake_up_var(&cookie->state);
+}
+
+static void __fscache_set_cookie_state(struct fscache_cookie *cookie,
+				       enum fscache_cookie_state state)
+{
+	cookie->state = state;
+}
+
+/*
+ * Change the state a cookie is at and wake up anyone waiting for that - but
+ * only if the cookie isn't already marked as being in a cleanup state.
+ */
+void fscache_set_cookie_state(struct fscache_cookie *cookie,
+			      enum fscache_cookie_state state)
+{
+	bool changed = false;
+
+	spin_lock(&cookie->lock);
+	switch (cookie->state) {
+	case FSCACHE_COOKIE_STATE_RELINQUISHING:
+		break;
+	default:
+		__fscache_set_cookie_state(cookie, state);
+		changed = true;
+		break;
+	}
+	spin_unlock(&cookie->lock);
+	if (changed)
+		wake_up_cookie_state(cookie);
+}
+EXPORT_SYMBOL(fscache_set_cookie_state);
+
+/*
+ * Set the index key in a cookie.  The cookie struct has space for a 16-byte
+ * key plus length and hash, but if that's not big enough, it's instead a
+ * pointer to a buffer containing 3 bytes of hash, 1 byte of length and then
+ * the key data.
+ */
+static int fscache_set_key(struct fscache_cookie *cookie,
+			   const void *index_key, size_t index_key_len)
+{
+	void *buf;
+	size_t buf_size;
+
+	buf_size = round_up(index_key_len, sizeof(__le32));
+
+	if (index_key_len > sizeof(cookie->inline_key)) {
+		buf = kzalloc(buf_size, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+		cookie->key = buf;
+	} else {
+		buf = cookie->inline_key;
+	}
+
+	memcpy(buf, index_key, index_key_len);
+	cookie->key_hash = fscache_hash(cookie->volume->key_hash,
+					buf, buf_size);
+	return 0;
+}
+
+static bool fscache_cookie_same(const struct fscache_cookie *a,
+				const struct fscache_cookie *b)
+{
+	const void *ka, *kb;
+
+	if (a->key_hash	!= b->key_hash ||
+	    a->volume	!= b->volume ||
+	    a->key_len	!= b->key_len)
+		return false;
+
+	if (a->key_len <= sizeof(a->inline_key)) {
+		ka = &a->inline_key;
+		kb = &b->inline_key;
+	} else {
+		ka = a->key;
+		kb = b->key;
+	}
+	return memcmp(ka, kb, a->key_len) == 0;
+}
+
+static atomic_t fscache_cookie_debug_id = ATOMIC_INIT(1);
+
+/*
+ * Allocate a cookie.
+ */
+static struct fscache_cookie *fscache_alloc_cookie(
+	struct fscache_volume *volume,
+	u8 advice,
+	const void *index_key, size_t index_key_len,
+	const void *aux_data, size_t aux_data_len,
+	loff_t object_size)
+{
+	struct fscache_cookie *cookie;
+
+	/* allocate and initialise a cookie */
+	cookie = kmem_cache_zalloc(fscache_cookie_jar, GFP_KERNEL);
+	if (!cookie)
+		return NULL;
+	fscache_stat(&fscache_n_cookies);
+
+	cookie->volume		= volume;
+	cookie->advice		= advice;
+	cookie->key_len		= index_key_len;
+	cookie->aux_len		= aux_data_len;
+	cookie->object_size	= object_size;
+	if (object_size == 0)
+		__set_bit(FSCACHE_COOKIE_NO_DATA_TO_READ, &cookie->flags);
+
+	if (fscache_set_key(cookie, index_key, index_key_len) < 0)
+		goto nomem;
+
+	if (cookie->aux_len <= sizeof(cookie->inline_aux)) {
+		memcpy(cookie->inline_aux, aux_data, cookie->aux_len);
+	} else {
+		cookie->aux = kmemdup(aux_data, cookie->aux_len, GFP_KERNEL);
+		if (!cookie->aux)
+			goto nomem;
+	}
+
+	refcount_set(&cookie->ref, 1);
+	cookie->debug_id = atomic_inc_return(&fscache_cookie_debug_id);
+	cookie->state = FSCACHE_COOKIE_STATE_QUIESCENT;
+	spin_lock_init(&cookie->lock);
+	INIT_LIST_HEAD(&cookie->commit_link);
+	INIT_WORK(&cookie->work, NULL /* PLACEHOLDER */);
+
+	write_lock(&fscache_cookies_lock);
+	list_add_tail(&cookie->proc_link, &fscache_cookies);
+	write_unlock(&fscache_cookies_lock);
+	fscache_see_cookie(cookie, fscache_cookie_new_acquire);
+	return cookie;
+
+nomem:
+	fscache_free_cookie(cookie);
+	return NULL;
+}
+
+static void fscache_wait_on_collision(struct fscache_cookie *candidate,
+				      struct fscache_cookie *wait_for)
+{
+	enum fscache_cookie_state *statep = &wait_for->state;
+
+	wait_var_event_timeout(statep, READ_ONCE(*statep) == FSCACHE_COOKIE_STATE_DROPPED,
+			       20 * HZ);
+	if (READ_ONCE(*statep) != FSCACHE_COOKIE_STATE_DROPPED) {
+		pr_notice("Potential collision c=%08x old: c=%08x",
+			  candidate->debug_id, wait_for->debug_id);
+		wait_var_event(statep, READ_ONCE(*statep) == FSCACHE_COOKIE_STATE_DROPPED);
+	}
+}
+
+/*
+ * Attempt to insert the new cookie into the hash.  If there's a collision, we
+ * wait for the old cookie to complete if it's being relinquished and an error
+ * otherwise.
+ */
+static bool fscache_hash_cookie(struct fscache_cookie *candidate)
+{
+	struct fscache_cookie *cursor, *wait_for = NULL;
+	struct hlist_bl_head *h;
+	struct hlist_bl_node *p;
+	unsigned int bucket;
+
+	bucket = candidate->key_hash & (ARRAY_SIZE(fscache_cookie_hash) - 1);
+	h = &fscache_cookie_hash[bucket];
+
+	hlist_bl_lock(h);
+	hlist_bl_for_each_entry(cursor, p, h, hash_link) {
+		if (fscache_cookie_same(candidate, cursor)) {
+			if (!test_bit(FSCACHE_COOKIE_RELINQUISHED, &cursor->flags))
+				goto collision;
+			wait_for = fscache_get_cookie(cursor,
+						      fscache_cookie_get_hash_collision);
+			break;
+		}
+	}
+
+	fscache_get_volume(candidate->volume, fscache_volume_get_cookie);
+	atomic_inc(&candidate->volume->n_cookies);
+	hlist_bl_add_head(&candidate->hash_link, h);
+	set_bit(FSCACHE_COOKIE_IS_HASHED, &candidate->flags);
+	hlist_bl_unlock(h);
+
+	if (wait_for) {
+		fscache_wait_on_collision(candidate, wait_for);
+		fscache_put_cookie(wait_for, fscache_cookie_put_hash_collision);
+	}
+	return true;
+
+collision:
+	trace_fscache_cookie(cursor->debug_id, refcount_read(&cursor->ref),
+			     fscache_cookie_collision);
+	pr_err("Duplicate cookie detected\n");
+	fscache_print_cookie(cursor, 'O');
+	fscache_print_cookie(candidate, 'N');
+	hlist_bl_unlock(h);
+	return false;
+}
+
+/*
+ * Request a cookie to represent a data storage object within a volume.
+ *
+ * We never let on to the netfs about errors.  We may set a negative cookie
+ * pointer, but that's okay
+ */
+struct fscache_cookie *__fscache_acquire_cookie(
+	struct fscache_volume *volume,
+	u8 advice,
+	const void *index_key, size_t index_key_len,
+	const void *aux_data, size_t aux_data_len,
+	loff_t object_size)
+{
+	struct fscache_cookie *cookie;
+
+	_enter("V=%x", volume->debug_id);
+
+	if (!index_key || !index_key_len || index_key_len > 255 || aux_data_len > 255)
+		return NULL;
+	if (!aux_data || !aux_data_len) {
+		aux_data = NULL;
+		aux_data_len = 0;
+	}
+
+	fscache_stat(&fscache_n_acquires);
+
+	cookie = fscache_alloc_cookie(volume, advice,
+				      index_key, index_key_len,
+				      aux_data, aux_data_len,
+				      object_size);
+	if (!cookie) {
+		fscache_stat(&fscache_n_acquires_oom);
+		return NULL;
+	}
+
+	if (!fscache_hash_cookie(cookie)) {
+		fscache_see_cookie(cookie, fscache_cookie_discard);
+		fscache_free_cookie(cookie);
+		return NULL;
+	}
+
+	trace_fscache_acquire(cookie);
+	fscache_stat(&fscache_n_acquires_ok);
+	_leave(" = c=%08x", cookie->debug_id);
+	return cookie;
+}
+EXPORT_SYMBOL(__fscache_acquire_cookie);
+
+/*
+ * Remove a cookie from the hash table.
+ */
+static void fscache_unhash_cookie(struct fscache_cookie *cookie)
+{
+	struct hlist_bl_head *h;
+	unsigned int bucket;
+
+	bucket = cookie->key_hash & (ARRAY_SIZE(fscache_cookie_hash) - 1);
+	h = &fscache_cookie_hash[bucket];
+
+	hlist_bl_lock(h);
+	hlist_bl_del(&cookie->hash_link);
+	clear_bit(FSCACHE_COOKIE_IS_HASHED, &cookie->flags);
+	hlist_bl_unlock(h);
+}
+
+/*
+ * Finalise a cookie after all its resources have been disposed of.
+ */
+static void fscache_drop_cookie(struct fscache_cookie *cookie)
+{
+	spin_lock(&cookie->lock);
+	__fscache_set_cookie_state(cookie, FSCACHE_COOKIE_STATE_DROPPED);
+	spin_unlock(&cookie->lock);
+	wake_up_cookie_state(cookie);
+
+	fscache_unhash_cookie(cookie);
+	fscache_stat(&fscache_n_relinquishes_dropped);
+}
+
+/*
+ * Allow the netfs to release a cookie back to the cache.
+ * - the object will be marked as recyclable on disk if retire is true
+ */
+void __fscache_relinquish_cookie(struct fscache_cookie *cookie, bool retire)
+{
+	fscache_stat(&fscache_n_relinquishes);
+	if (retire)
+		fscache_stat(&fscache_n_relinquishes_retire);
+
+	_enter("c=%08x{%d},%d",
+	       cookie->debug_id, atomic_read(&cookie->n_active), retire);
+
+	if (WARN(test_and_set_bit(FSCACHE_COOKIE_RELINQUISHED, &cookie->flags),
+		 "Cookie c=%x already relinquished\n", cookie->debug_id))
+		return;
+
+	if (retire)
+		set_bit(FSCACHE_COOKIE_RETIRED, &cookie->flags);
+	trace_fscache_relinquish(cookie, retire);
+
+	ASSERTCMP(atomic_read(&cookie->n_active), ==, 0);
+	ASSERTCMP(atomic_read(&cookie->volume->n_cookies), >, 0);
+	atomic_dec(&cookie->volume->n_cookies);
+
+	set_bit(FSCACHE_COOKIE_DO_RELINQUISH, &cookie->flags);
+
+	if (test_bit(FSCACHE_COOKIE_HAS_BEEN_CACHED, &cookie->flags))
+		; // PLACEHOLDER: Do something here if the cookie was cached
+	else
+		fscache_drop_cookie(cookie);
+	fscache_put_cookie(cookie, fscache_cookie_put_relinquish);
+}
+EXPORT_SYMBOL(__fscache_relinquish_cookie);
+
+/*
+ * Drop a reference to a cookie.
+ */
+void fscache_put_cookie(struct fscache_cookie *cookie,
+			enum fscache_cookie_trace where)
+{
+	struct fscache_volume *volume = cookie->volume;
+	unsigned int cookie_debug_id = cookie->debug_id;
+	bool zero;
+	int ref;
+
+	zero = __refcount_dec_and_test(&cookie->ref, &ref);
+	trace_fscache_cookie(cookie_debug_id, ref - 1, where);
+	if (zero) {
+		fscache_free_cookie(cookie);
+		fscache_put_volume(volume, fscache_volume_put_cookie);
+	}
+}
+EXPORT_SYMBOL(fscache_put_cookie);
+
+/*
+ * Get a reference to a cookie.
+ */
+struct fscache_cookie *fscache_get_cookie(struct fscache_cookie *cookie,
+					  enum fscache_cookie_trace where)
+{
+	int ref;
+
+	__refcount_inc(&cookie->ref, &ref);
+	trace_fscache_cookie(cookie->debug_id, ref + 1, where);
+	return cookie;
+}
+EXPORT_SYMBOL(fscache_get_cookie);
+
+/*
+ * Generate a list of extant cookies in /proc/fs/fscache/cookies
+ */
+static int fscache_cookies_seq_show(struct seq_file *m, void *v)
+{
+	struct fscache_cookie *cookie;
+	unsigned int keylen = 0, auxlen = 0;
+	u8 *p;
+
+	if (v == &fscache_cookies) {
+		seq_puts(m,
+			 "COOKIE   VOLUME   REF ACT ACC S FL DEF             \n"
+			 "======== ======== === === === = == ================\n"
+			 );
+		return 0;
+	}
+
+	cookie = list_entry(v, struct fscache_cookie, proc_link);
+
+	seq_printf(m,
+		   "%08x %08x %3d %3d %3d %c %02lx",
+		   cookie->debug_id,
+		   cookie->volume->debug_id,
+		   refcount_read(&cookie->ref),
+		   atomic_read(&cookie->n_active),
+		   atomic_read(&cookie->n_accesses),
+		   fscache_cookie_states[cookie->state],
+		   cookie->flags);
+
+	keylen = cookie->key_len;
+	auxlen = cookie->aux_len;
+
+	if (keylen > 0 || auxlen > 0) {
+		seq_puts(m, " ");
+		p = keylen <= sizeof(cookie->inline_key) ?
+			cookie->inline_key : cookie->key;
+		for (; keylen > 0; keylen--)
+			seq_printf(m, "%02x", *p++);
+		if (auxlen > 0) {
+			seq_puts(m, ", ");
+			p = auxlen <= sizeof(cookie->inline_aux) ?
+				cookie->inline_aux : cookie->aux;
+			for (; auxlen > 0; auxlen--)
+				seq_printf(m, "%02x", *p++);
+		}
+	}
+
+	seq_puts(m, "\n");
+	return 0;
+}
+
+static void *fscache_cookies_seq_start(struct seq_file *m, loff_t *_pos)
+	__acquires(fscache_cookies_lock)
+{
+	read_lock(&fscache_cookies_lock);
+	return seq_list_start_head(&fscache_cookies, *_pos);
+}
+
+static void *fscache_cookies_seq_next(struct seq_file *m, void *v, loff_t *_pos)
+{
+	return seq_list_next(v, &fscache_cookies, _pos);
+}
+
+static void fscache_cookies_seq_stop(struct seq_file *m, void *v)
+	__releases(rcu)
+{
+	read_unlock(&fscache_cookies_lock);
+}
+
+
+const struct seq_operations fscache_cookies_seq_ops = {
+	.start  = fscache_cookies_seq_start,
+	.next   = fscache_cookies_seq_next,
+	.stop   = fscache_cookies_seq_stop,
+	.show   = fscache_cookies_seq_show,
+};
diff --git a/fs/fscache/internal.h b/fs/fscache/internal.h
index 07dc9cbc2280..71c897757d44 100644
--- a/fs/fscache/internal.h
+++ b/fs/fscache/internal.h
@@ -50,6 +50,20 @@ static inline bool fscache_set_cache_state_maybe(struct fscache_cache *cache,
 	return try_cmpxchg_release(&cache->state, &old_state, new_state);
 }
 
+/*
+ * cookie.c
+ */
+extern struct kmem_cache *fscache_cookie_jar;
+extern const struct seq_operations fscache_cookies_seq_ops;
+
+extern void fscache_print_cookie(struct fscache_cookie *cookie, char prefix);
+static inline void fscache_see_cookie(struct fscache_cookie *cookie,
+				      enum fscache_cookie_trace where)
+{
+	trace_fscache_cookie(cookie->debug_id, refcount_read(&cookie->ref),
+			     where);
+}
+
 /*
  * main.c
  */
@@ -75,6 +89,15 @@ extern void fscache_proc_cleanup(void);
 extern atomic_t fscache_n_volumes;
 extern atomic_t fscache_n_volumes_collision;
 extern atomic_t fscache_n_volumes_nomem;
+extern atomic_t fscache_n_cookies;
+
+extern atomic_t fscache_n_acquires;
+extern atomic_t fscache_n_acquires_ok;
+extern atomic_t fscache_n_acquires_oom;
+
+extern atomic_t fscache_n_relinquishes;
+extern atomic_t fscache_n_relinquishes_retire;
+extern atomic_t fscache_n_relinquishes_dropped;
 
 static inline void fscache_stat(atomic_t *stat)
 {
diff --git a/fs/fscache/main.c b/fs/fscache/main.c
index 687b34903d5b..ae493e9ca1c9 100644
--- a/fs/fscache/main.c
+++ b/fs/fscache/main.c
@@ -79,9 +79,20 @@ static int __init fscache_init(void)
 	if (ret < 0)
 		goto error_proc;
 
+	fscache_cookie_jar = kmem_cache_create("fscache_cookie_jar",
+					       sizeof(struct fscache_cookie),
+					       0, 0, NULL);
+	if (!fscache_cookie_jar) {
+		pr_notice("Failed to allocate a cookie jar\n");
+		ret = -ENOMEM;
+		goto error_cookie_jar;
+	}
+
 	pr_notice("Loaded\n");
 	return 0;
 
+error_cookie_jar:
+	fscache_proc_cleanup();
 error_proc:
 	destroy_workqueue(fscache_wq);
 error_wq:
@@ -97,6 +108,7 @@ static void __exit fscache_exit(void)
 {
 	_enter("");
 
+	kmem_cache_destroy(fscache_cookie_jar);
 	fscache_proc_cleanup();
 	destroy_workqueue(fscache_wq);
 	pr_notice("Unloaded\n");
diff --git a/fs/fscache/proc.c b/fs/fscache/proc.c
index bc6ecbdd065d..dc3b0e9c8cce 100644
--- a/fs/fscache/proc.c
+++ b/fs/fscache/proc.c
@@ -27,6 +27,10 @@ int __init fscache_proc_init(void)
 			     &fscache_volumes_seq_ops))
 		goto error;
 
+	if (!proc_create_seq("fs/fscache/cookies", S_IFREG | 0444, NULL,
+			     &fscache_cookies_seq_ops))
+		goto error;
+
 #ifdef CONFIG_FSCACHE_STATS
 	if (!proc_create_single("fs/fscache/stats", S_IFREG | 0444, NULL,
 				fscache_stats_show))
diff --git a/fs/fscache/stats.c b/fs/fscache/stats.c
index b811a4d03585..252e883ae148 100644
--- a/fs/fscache/stats.c
+++ b/fs/fscache/stats.c
@@ -16,6 +16,18 @@
 atomic_t fscache_n_volumes;
 atomic_t fscache_n_volumes_collision;
 atomic_t fscache_n_volumes_nomem;
+atomic_t fscache_n_cookies;
+
+atomic_t fscache_n_acquires;
+atomic_t fscache_n_acquires_ok;
+atomic_t fscache_n_acquires_oom;
+
+atomic_t fscache_n_updates;
+EXPORT_SYMBOL(fscache_n_updates);
+
+atomic_t fscache_n_relinquishes;
+atomic_t fscache_n_relinquishes_retire;
+atomic_t fscache_n_relinquishes_dropped;
 
 /*
  * display the general statistics
@@ -23,12 +35,26 @@ atomic_t fscache_n_volumes_nomem;
 int fscache_stats_show(struct seq_file *m, void *v)
 {
 	seq_puts(m, "FS-Cache statistics\n");
-	seq_printf(m, "Cookies: v=%d vcol=%u voom=%u\n",
+	seq_printf(m, "Cookies: n=%d v=%d vcol=%u voom=%u\n",
+		   atomic_read(&fscache_n_cookies),
 		   atomic_read(&fscache_n_volumes),
 		   atomic_read(&fscache_n_volumes_collision),
 		   atomic_read(&fscache_n_volumes_nomem)
 		   );
 
+	seq_printf(m, "Acquire: n=%u ok=%u oom=%u\n",
+		   atomic_read(&fscache_n_acquires),
+		   atomic_read(&fscache_n_acquires_ok),
+		   atomic_read(&fscache_n_acquires_oom));
+
+	seq_printf(m, "Updates: n=%u\n",
+		   atomic_read(&fscache_n_updates));
+
+	seq_printf(m, "Relinqs: n=%u rtr=%u drop=%u\n",
+		   atomic_read(&fscache_n_relinquishes),
+		   atomic_read(&fscache_n_relinquishes_retire),
+		   atomic_read(&fscache_n_relinquishes_dropped));
+
 	netfs_stats_show(m);
 	return 0;
 }
diff --git a/include/linux/fscache-cache.h b/include/linux/fscache-cache.h
index 18cd5c9877bb..c4355b888c91 100644
--- a/include/linux/fscache-cache.h
+++ b/include/linux/fscache-cache.h
@@ -17,6 +17,7 @@
 #include <linux/fscache.h>
 
 enum fscache_cache_trace;
+enum fscache_cookie_trace;
 enum fscache_access_trace;
 
 enum fscache_cache_state {
@@ -52,4 +53,25 @@ extern struct rw_semaphore fscache_addremove_sem;
 extern struct fscache_cache *fscache_acquire_cache(const char *name);
 extern void fscache_relinquish_cache(struct fscache_cache *cache);
 
+extern struct fscache_cookie *fscache_get_cookie(struct fscache_cookie *cookie,
+						 enum fscache_cookie_trace where);
+extern void fscache_put_cookie(struct fscache_cookie *cookie,
+			       enum fscache_cookie_trace where);
+extern void fscache_set_cookie_state(struct fscache_cookie *cookie,
+				     enum fscache_cookie_state state);
+
+/**
+ * fscache_get_key - Get a pointer to the cookie key
+ * @cookie: The cookie to query
+ *
+ * Return a pointer to the where a cookie's key is stored.
+ */
+static inline void *fscache_get_key(struct fscache_cookie *cookie)
+{
+	if (cookie->key_len <= sizeof(cookie->inline_key))
+		return cookie->inline_key;
+	else
+		return cookie->key;
+}
+
 #endif /* _LINUX_FSCACHE_CACHE_H */
diff --git a/include/linux/fscache.h b/include/linux/fscache.h
index f2699a92774b..5c57a3ee2145 100644
--- a/include/linux/fscache.h
+++ b/include/linux/fscache.h
@@ -31,6 +31,27 @@
 #define fscache_cookie_enabled(cookie) (0)
 #endif
 
+struct fscache_cookie;
+
+#define FSCACHE_ADV_SINGLE_CHUNK	0x01 /* The object is a single chunk of data */
+#define FSCACHE_ADV_WRITE_CACHE		0x00 /* Do cache if written to locally */
+#define FSCACHE_ADV_WRITE_NOCACHE	0x02 /* Don't cache if written to locally */
+
+/*
+ * Data object state.
+ */
+enum fscache_cookie_state {
+	FSCACHE_COOKIE_STATE_QUIESCENT,		/* The cookie is uncached */
+	FSCACHE_COOKIE_STATE_LOOKING_UP,	/* The cache object is being looked up */
+	FSCACHE_COOKIE_STATE_CREATING,		/* The cache object is being created */
+	FSCACHE_COOKIE_STATE_ACTIVE,		/* The cache is active, readable and writable */
+	FSCACHE_COOKIE_STATE_FAILED,		/* The cache failed, withdraw to clear */
+	FSCACHE_COOKIE_STATE_WITHDRAWING,	/* The cookie is being withdrawn */
+	FSCACHE_COOKIE_STATE_RELINQUISHING,	/* The cookie is being relinquished */
+	FSCACHE_COOKIE_STATE_DROPPED,		/* The cookie has been dropped */
+#define FSCACHE_COOKIE_STATE__NR (FSCACHE_COOKIE_STATE_DROPPED + 1)
+} __attribute__((mode(byte)));
+
 /*
  * Volume representation cookie.
  */
@@ -55,6 +76,60 @@ struct fscache_volume {
 #define FSCACHE_VOLUME_CREATING		4	/* Volume is being created on disk */
 };
 
+/*
+ * Data file representation cookie.
+ * - a file will only appear in one cache
+ * - a request to cache a file may or may not be honoured, subject to
+ *   constraints such as disk space
+ * - indices are created on disk just-in-time
+ */
+struct fscache_cookie {
+	refcount_t			ref;
+	atomic_t			n_active;	/* number of active users of cookie */
+	atomic_t			n_accesses;	/* Number of cache accesses in progress */
+	unsigned int			debug_id;
+	unsigned int			inval_counter;	/* Number of invalidations made */
+	spinlock_t			lock;
+	struct fscache_volume		*volume;	/* Parent volume of this file. */
+	void				*cache_priv;	/* Cache-side representation */
+	struct hlist_bl_node		hash_link;	/* Link in hash table */
+	struct list_head		proc_link;	/* Link in proc list */
+	struct list_head		commit_link;	/* Link in commit queue */
+	struct work_struct		work;		/* Commit/relinq/withdraw work */
+	loff_t				object_size;	/* Size of the netfs object */
+	unsigned long			unused_at;	/* Time at which unused (jiffies) */
+	unsigned long			flags;
+#define FSCACHE_COOKIE_RELINQUISHED	0		/* T if cookie has been relinquished */
+#define FSCACHE_COOKIE_RETIRED		1		/* T if this cookie has retired on relinq */
+#define FSCACHE_COOKIE_IS_CACHING	2		/* T if this cookie is cached */
+#define FSCACHE_COOKIE_NO_DATA_TO_READ	3		/* T if this cookie has nothing to read */
+#define FSCACHE_COOKIE_NEEDS_UPDATE	4		/* T if attrs have been updated */
+#define FSCACHE_COOKIE_HAS_BEEN_CACHED	5		/* T if cookie needs withdraw-on-relinq */
+#define FSCACHE_COOKIE_DISABLED		6		/* T if cookie has been disabled */
+#define FSCACHE_COOKIE_LOCAL_WRITE	7		/* T if cookie has been modified locally */
+#define FSCACHE_COOKIE_NO_ACCESS_WAKE	8		/* T if no wake when n_accesses goes 0 */
+#define FSCACHE_COOKIE_DO_RELINQUISH	9		/* T if this cookie needs relinquishment */
+#define FSCACHE_COOKIE_DO_WITHDRAW	10		/* T if this cookie needs withdrawing */
+#define FSCACHE_COOKIE_DO_LRU_DISCARD	11		/* T if this cookie needs LRU discard */
+#define FSCACHE_COOKIE_DO_PREP_TO_WRITE	12		/* T if cookie needs write preparation */
+#define FSCACHE_COOKIE_HAVE_DATA	13		/* T if this cookie has data stored */
+#define FSCACHE_COOKIE_IS_HASHED	14		/* T if this cookie is hashed */
+
+	enum fscache_cookie_state	state;
+	u8				advice;		/* FSCACHE_ADV_* */
+	u8				key_len;	/* Length of index key */
+	u8				aux_len;	/* Length of auxiliary data */
+	u32				key_hash;	/* Hash of volume, key, len */
+	union {
+		void			*key;		/* Index key */
+		u8			inline_key[16];	/* - If the key is short enough */
+	};
+	union {
+		void			*aux;		/* Auxiliary data */
+		u8			inline_aux[8];	/* - If the aux data is short enough */
+	};
+};
+
 /*
  * slow-path functions for when there is actually caching available, and the
  * netfs does actually have a valid token
@@ -66,6 +141,14 @@ extern struct fscache_volume *__fscache_acquire_volume(const char *, const char
 						       const void *, size_t);
 extern void __fscache_relinquish_volume(struct fscache_volume *, const void *, bool);
 
+extern struct fscache_cookie *__fscache_acquire_cookie(
+	struct fscache_volume *,
+	u8,
+	const void *, size_t,
+	const void *, size_t,
+	loff_t);
+extern void __fscache_relinquish_cookie(struct fscache_cookie *, bool);
+
 /**
  * fscache_acquire_volume - Register a volume as desiring caching services
  * @volume_key: An identification string for the volume
@@ -114,4 +197,55 @@ void fscache_relinquish_volume(struct fscache_volume *volume,
 		__fscache_relinquish_volume(volume, coherency_data, invalidate);
 }
 
+/**
+ * fscache_acquire_cookie - Acquire a cookie to represent a cache object
+ * @volume: The volume in which to locate/create this cookie
+ * @advice: Advice flags (FSCACHE_COOKIE_ADV_*)
+ * @index_key: The index key for this cookie
+ * @index_key_len: Size of the index key
+ * @aux_data: The auxiliary data for the cookie (may be NULL)
+ * @aux_data_len: Size of the auxiliary data buffer
+ * @object_size: The initial size of object
+ *
+ * Acquire a cookie to represent a data file within the given cache volume.
+ *
+ * See Documentation/filesystems/caching/netfs-api.rst for a complete
+ * description.
+ */
+static inline
+struct fscache_cookie *fscache_acquire_cookie(struct fscache_volume *volume,
+					      u8 advice,
+					      const void *index_key,
+					      size_t index_key_len,
+					      const void *aux_data,
+					      size_t aux_data_len,
+					      loff_t object_size)
+{
+	if (!fscache_volume_valid(volume))
+		return NULL;
+	return __fscache_acquire_cookie(volume, advice,
+					index_key, index_key_len,
+					aux_data, aux_data_len,
+					object_size);
+}
+
+/**
+ * fscache_relinquish_cookie - Return the cookie to the cache, maybe discarding
+ * it
+ * @cookie: The cookie being returned
+ * @retire: True if the cache object the cookie represents is to be discarded
+ *
+ * This function returns a cookie to the cache, forcibly discarding the
+ * associated cache object if retire is set to true.
+ *
+ * See Documentation/filesystems/caching/netfs-api.rst for a complete
+ * description.
+ */
+static inline
+void fscache_relinquish_cookie(struct fscache_cookie *cookie, bool retire)
+{
+	if (fscache_cookie_valid(cookie))
+		__fscache_relinquish_cookie(cookie, retire);
+}
+
 #endif /* _LINUX_FSCACHE_H */
diff --git a/include/trace/events/fscache.h b/include/trace/events/fscache.h
index eeb3e7d88e20..9286e1c4b2ac 100644
--- a/include/trace/events/fscache.h
+++ b/include/trace/events/fscache.h
@@ -45,6 +45,23 @@ enum fscache_volume_trace {
 	fscache_volume_see_hash_wake,
 };
 
+enum fscache_cookie_trace {
+	fscache_cookie_collision,
+	fscache_cookie_discard,
+	fscache_cookie_get_end_access,
+	fscache_cookie_get_hash_collision,
+	fscache_cookie_new_acquire,
+	fscache_cookie_put_hash_collision,
+	fscache_cookie_put_over_queued,
+	fscache_cookie_put_relinquish,
+	fscache_cookie_put_withdrawn,
+	fscache_cookie_put_work,
+	fscache_cookie_see_active,
+	fscache_cookie_see_relinquish,
+	fscache_cookie_see_withdraw,
+	fscache_cookie_see_work,
+};
+
 #endif
 
 /*
@@ -74,6 +91,22 @@ enum fscache_volume_trace {
 	EM(fscache_volume_see_create_work,	"SEE creat")		\
 	E_(fscache_volume_see_hash_wake,	"SEE hwake")
 
+#define fscache_cookie_traces						\
+	EM(fscache_cookie_collision,		"*COLLIDE*")		\
+	EM(fscache_cookie_discard,		"DISCARD  ")		\
+	EM(fscache_cookie_get_hash_collision,	"GET hcoll")		\
+	EM(fscache_cookie_get_end_access,	"GQ  endac")		\
+	EM(fscache_cookie_new_acquire,		"NEW acq  ")		\
+	EM(fscache_cookie_put_hash_collision,	"PUT hcoll")		\
+	EM(fscache_cookie_put_over_queued,	"PQ  overq")		\
+	EM(fscache_cookie_put_relinquish,	"PUT relnq")		\
+	EM(fscache_cookie_put_withdrawn,	"PUT wthdn")		\
+	EM(fscache_cookie_put_work,		"PQ  work ")		\
+	EM(fscache_cookie_see_active,		"-   activ")		\
+	EM(fscache_cookie_see_relinquish,	"-   x-rlq")		\
+	EM(fscache_cookie_see_withdraw,		"-   x-wth")		\
+	E_(fscache_cookie_see_work,		"-   work ")
+
 /*
  * Export enum symbols via userspace.
  */
@@ -84,6 +117,7 @@ enum fscache_volume_trace {
 
 fscache_cache_traces;
 fscache_volume_traces;
+fscache_cookie_traces;
 
 /*
  * Now redefine the EM() and E_() macros to map the enums to the strings that
@@ -145,6 +179,83 @@ TRACE_EVENT(fscache_volume,
 		      __entry->usage)
 	    );
 
+TRACE_EVENT(fscache_cookie,
+	    TP_PROTO(unsigned int cookie_debug_id,
+		     int ref,
+		     enum fscache_cookie_trace where),
+
+	    TP_ARGS(cookie_debug_id, ref, where),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,		cookie		)
+		    __field(int,			ref		)
+		    __field(enum fscache_cookie_trace,	where		)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->cookie	= cookie_debug_id;
+		    __entry->ref	= ref;
+		    __entry->where	= where;
+			   ),
+
+	    TP_printk("c=%08x %s r=%d",
+		      __entry->cookie,
+		      __print_symbolic(__entry->where, fscache_cookie_traces),
+		      __entry->ref)
+	    );
+
+TRACE_EVENT(fscache_acquire,
+	    TP_PROTO(struct fscache_cookie *cookie),
+
+	    TP_ARGS(cookie),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,		cookie		)
+		    __field(unsigned int,		volume		)
+		    __field(int,			v_ref		)
+		    __field(int,			v_n_cookies	)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->cookie		= cookie->debug_id;
+		    __entry->volume		= cookie->volume->debug_id;
+		    __entry->v_ref		= refcount_read(&cookie->volume->ref);
+		    __entry->v_n_cookies	= atomic_read(&cookie->volume->n_cookies);
+			   ),
+
+	    TP_printk("c=%08x V=%08x vr=%d vc=%d",
+		      __entry->cookie,
+		      __entry->volume, __entry->v_ref, __entry->v_n_cookies)
+	    );
+
+TRACE_EVENT(fscache_relinquish,
+	    TP_PROTO(struct fscache_cookie *cookie, bool retire),
+
+	    TP_ARGS(cookie, retire),
+
+	    TP_STRUCT__entry(
+		    __field(unsigned int,		cookie		)
+		    __field(unsigned int,		volume		)
+		    __field(int,			ref		)
+		    __field(int,			n_active	)
+		    __field(u8,				flags		)
+		    __field(bool,			retire		)
+			     ),
+
+	    TP_fast_assign(
+		    __entry->cookie	= cookie->debug_id;
+		    __entry->volume	= cookie->volume->debug_id;
+		    __entry->ref	= refcount_read(&cookie->ref);
+		    __entry->n_active	= atomic_read(&cookie->n_active);
+		    __entry->flags	= cookie->flags;
+		    __entry->retire	= retire;
+			   ),
+
+	    TP_printk("c=%08x V=%08x r=%d U=%d f=%02x rt=%u",
+		      __entry->cookie, __entry->volume, __entry->ref,
+		      __entry->n_active, __entry->flags, __entry->retire)
+	    );
+
 #endif /* _TRACE_FSCACHE_H */
 
 /* This part must be outside protection */


